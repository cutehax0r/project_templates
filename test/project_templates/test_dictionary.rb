# frozen_string_literal: true

require "test_helper"

class TestDictionary < Minitest::Test
  include ClassUnderTest

  def test_initializes_with_yaml
    input = <<~YAML
      ---
      foo: 123
    YAML
    class_under_test.load(input)
  end

  def test_loads_with_json
    input = '{"foo": 123}'
    class_under_test.load(input)
  end

  def test_implements_method_missing
    input = '{"foo": 123}'
    dict = class_under_test.new(input)
    assert_equal(123, dict.foo)
    assert_raises(NoMethodError) { dict.bar }
  end

  def test_implemements_respond_to_missing
    input = '{"foo": 123}'
    dict = class_under_test.new(input)
    assert(dict.respond_to?(:foo))
    refute(dict.respond_to?(:bar))
    assert_instance_of(Method, dict.method(:foo))
    assert_raises(NameError) { dict.method(:bar) }
  end

  def test_initializes_with_json
    input = '{"foo": 123}'
    class_under_test.new(input)
  end

  def test_nested_keys_in_yaml
    input = <<~YAML
      ---
      foo: 123
      bar:
        bing: 456
        bong: 789
    YAML
    dict = class_under_test.load(input)
    assert_equal(123, dict.foo)
    assert_equal(456, dict.bar.bing)
    assert_equal(789, dict.bar.bong)
    assert_raises(NoMethodError) { dict.baz }
  end

  def test_throws_argument_error_on_yaml_that_doesnt_make_a_hash
    input = <<~YAML
      ---
      - foo
    YAML
    assert_raises(ArgumentError) { class_under_test.load(input) }
    assert_raises(ArgumentError) { class_under_test.new(input) }
  end

  def test_throws_argument_error_on_json_that_doesnt_make_a_hash
    input = "[1, 2, 3]"
    assert_raises(ArgumentError) { class_under_test.load(input) }
    assert_raises(ArgumentError) { class_under_test.new(input) }
  end

  def test_throws_argument_error_on_invalid_json
    input = "{invalid"
    assert_raises(ArgumentError) { class_under_test.load(input) }
    assert_raises(ArgumentError) { class_under_test.new(input) }
  end
end
