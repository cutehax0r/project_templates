# frozen_string_literal: true

require "test_helper"

class TestFile < MiniTest::Test
  include ClassUnderTest
  include FileHelper
  include MockEnv

  attr_reader :json, :source

  def setup
    @class_under_test = ProjectTemplates::Sources::File
    @source = class_under_test.new(file("valid.yaml", exist: true))
  end

  def test_has_a_description
    assert_equal(
      "Returns a dictionary from a string pointing to a file containing YAML or JSON.",
      class_under_test::DESCRIPTION
    )
  end

  def test_not_loadable_when_source_is_nonexistent_file
    @source = class_under_test.new(file("nil", exist: false))
    refute_predicate(source, :loadable?)
  end

  def test_loadable_when_source_is_set_to_a_file
    assert_predicate(source, :loadable?)
  end

  def test_loads_nil_on_unparsable_file
    @source = class_under_test.new(file("invalid.json", exist: true))
    assert_raises(ArgumentError) { source.load }
    assert_nil(source.dictionary)
  end

  def test_loads_a_dictionary_from_parsable_file
    source.load
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
  end
end
