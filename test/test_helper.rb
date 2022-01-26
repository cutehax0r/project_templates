# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "minitest/mock"
require "minitest/focus"
require "pry"

require "project_templates"

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
