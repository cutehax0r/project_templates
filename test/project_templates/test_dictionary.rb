# frozen_string_literal: true

require "test_helper"

class TestDictionary < Minitest::Test
  include ClassUnderTest

  def test_initializes_with_yaml
    input = <<~YAML
      ---
      foo: 123
    YAML
    dict = class_under_test.load(input)
    assert_equal 123, dict.foo
  end

  def test_loads_with_json
    input = '{"foo": 123}'
    dict = class_under_test.load(input)
    assert_equal 123, dict.foo
  end

  def test_loads_with_ruby_hash
    input = { foo: 123 }
    dict = class_under_test.load(input)
    assert_equal 123, dict.foo
  end

  def test_loads_with_openstruct
    input = OpenStruct.new(foo: 123)
    dict = class_under_test.load(input)
    assert_equal 123, dict.foo
  end

  def test_parse_is_another_spelling_of_load
    input = { foo: 123 }
    dict = class_under_test.parse(input)
    assert_equal 123, dict.foo
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

  def test_nested_keys_in_openstruct
    input = OpenStruct.new(foo: 123, bar: { bing: 456, bong: 789 })
    dict = class_under_test.load(input)
    assert_equal(123, dict.foo)
    assert_equal(456, dict.bar.bing)
    assert_equal(789, dict.bar.bong)
    assert_raises(NoMethodError) { dict.baz }
  end

  def test_new_is_private
    assert_raises(NoMethodError) { class_under_test.new }
  end

  def test_throws_argument_error_on_yaml_that_doesnt_make_a_hash
    input = <<~YAML
      ---
      - foo
    YAML
    assert_raises(ArgumentError) { class_under_test.load(input) }
  end

  def test_throws_argument_error_on_json_that_doesnt_make_a_hash
    input = "[1, 2, 3]"
    assert_raises(ArgumentError) { class_under_test.load(input) }
  end

  def test_throws_argument_error_on_invalid_json
    input = "{invalid"
    assert_raises(ArgumentError) { class_under_test.load(input) }
  end
end
