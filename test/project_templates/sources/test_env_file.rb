# frozen_string_literal: true

require "test_helper"

class TestEnvFile < MiniTest::Test
  include ClassUnderTest
  include FileHelper
  include MockEnv

  attr_reader :json, :source

  def setup
    @class_under_test = ProjectTemplates::Sources::EnvFile
    @source = mock_env(delete: "SOME_ENV") { class_under_test.new("SOME_ENV") }
  end

  def test_has_a_description
    assert_equal(
      "Returns a dictionary from a file containing YAML or JSON pointed at by an environment variable.",
      class_under_test::DESCRIPTION
    )
  end

  def test_not_loadable_when_env_is_unset
    refute_predicate(source, :loadable?)
  end

  def test_not_loadable_when_env_is_set_to_nonexistent_file
    @source = mock_env(SOME_ENV: file("nil", absolute: false, exist: false)) { class_under_test.new("SOME_ENV") }
    refute_predicate(source, :loadable?)
  end

  def test_loadable_when_env_is_set_to_a_file
    @source = mock_env(SOME_ENV: file("valid.json")) do
      class_under_test.new("SOME_ENV")
    end
    assert_predicate(source, :loadable?)
  end

  def test_loads_nil_on_unparsable_file
    @source = mock_env(SOME_ENV: file("invalid.json")) { class_under_test.new("SOME_ENV") }
    source.load
    assert_nil(source.dictionary)
  end

  def test_loads_a_dictionary_from_parsable_file
    @source = mock_env(SOME_ENV: file("valid.yaml")) { class_under_test.new("SOME_ENV") }
    source.load
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
  end
end
