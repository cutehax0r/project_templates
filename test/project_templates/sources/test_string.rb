# frozen_string_literal: true

require "test_helper"

class TestString < MiniTest::Test
  include ClassUnderTest
  attr_reader :json, :source

  def setup
    @json = { hello: "world" }.to_json
    @source = class_under_test.new(json)
  end

  def test_has_a_description
    assert_equal(
      "Returns a dictionary from a string that can be parsed as JSON or YAML.",
      class_under_test::DESCRIPTION
    )
  end

  def test_loadable
    assert_predicate(source, :loadable?)
  end

  def test_loads_nil_on_unparsable_string
    @source = class_under_test.new("")
    source.load
    assert_nil(source.dictionary)
  end

  def test_loads_a_dictionary_from_a_string
    source.load
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
    assert_equal(JSON.parse(json, symbolize_names: true), source.dictionary.to_h)
  end
end
