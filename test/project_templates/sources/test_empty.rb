# frozen_string_literal: true

require "test_helper"

class TestEmpty < MiniTest::Test
  include ClassUnderTest
  attr_reader :source

  def setup
    @source = class_under_test.new
  end

  def test_has_a_description
    assert_equal(
      "Returns an empty dictionary.",
      class_under_test::DESCRIPTION
    )
  end

  def test_loadable
    assert_predicate(source, :loadable?)
  end

  def test_loads_an_empty_dictionary
    source.load
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
  end
end
