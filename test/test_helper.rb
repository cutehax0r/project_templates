# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "minitest/mock"
require "minitest/focus"
require "pry"

require "project_templates"

module ClassUnderTest
  # This is a helper that returns the name of the class. This feature is
  # implemented pretty naively for the sake of readability. It maps
  # `TestFoobar` to `ProjectTemplates::Foobar`. At least for the moment a more
  # complicated helper is not required, just "include it into your test file"
  # to make it available.
  # TODO: make smarter: aware of namespaces. Walk up to test/ then prepend the
  # default namespace, swap / with :: and to 'camelcase stuff'
  def class_under_test
    return @class_under_test if defined?(@class_under_test)

    namespace = "ProjectTemplates"
    test_name = self.class.to_s
    full_class_name = [namespace, test_name[4..]].join("::")
    @class_under_test = Kernel.const_get(full_class_name)
  end
end

module FileHelper
  # A simple helper that builds paths that represent files in the fixture path.
  # it saves a bit of typing and makes the files a bit shorter
  def file(name, absolute: true, exist: true)
    path = Pathname.new(Dir.pwd).join("test/fixtures/files").join(name)
    message = "File #{name} exists where it should not. Found at #{path}" if !exist && path.exist?
    message = "File #{name} does not exist where it should. Expected at #{path}" if exist && !path.exist?
    raise(ArgumentError, message) if message

    absolute ? path.expand_path : path
  end
end

module MockEnv
  # A helper to mock environment variables.
  # * delete remove keys from the environment
  # * new_env is a hash that ADDS or REPLACES keys in the environment
  # Requires a block which is executed inside the mocked environment
  # ENV can be modified within the block as it is restored to once
  # the block returns.
  def mock_env(delete: [], **new_env, &block)
    original_env = ENV.to_h
    ENV.update(new_env.transform_keys(&:to_s).transform_keys(&:upcase).transform_values(&:to_s))
    [*delete].map(&:to_s).map(&:upcase).each { ENV.delete(_1) }
    yield(block)
  ensure
    ENV.replace(original_env)
  end
end

module HasAttributeHelper
  # A helper to ensure that a class has an attribute defined.
  #   * `instance` is the symbol for a method that will return an instance
  #      to assert on.
  #   * `attribute` is the symbol for the name of the attribute checked
  #   * `readable` ensures that the attribute is readable; which is to say
  #      that #attribute is defined.
  #   * `writable` ensures that the attribute is writable; which is to say
  #      that #attribute= is defined.
  #   * `interrogatable` ensures that the attribute is boolean-querable;
  #      which is to say that #attribute? is defined.
  # this tests only creates positive assertions: if `readable` is nil or
  # false then no assertion is created. a "refute_respond_to" assertion
  # will not be generated.
  def test_has_attribute(instance, attribute, readable: false, writable: false, interrogatable: false)
    attribute_kind = { readable:, writable:, interrogatable: }.select{_2}.keys
    test_name = "test_#{attribute}_is_a_#{attribute_kind.join('_')}"

    define_method(test_name.to_sym) do
      captured_instance = send(instance)
      assert_respond_to(captured_instance, attribute) if readable
      assert_respond_to(captured_instance, "#{attribute}=".to_sym) if writable
      assert_respond_to(captured_instance, "#{attribute}?".to_sym) if interrogatable
    end
  end
end
