# frozen_string_literal: true

require "test_helper"

class TestEnvFile < MiniTest::Test
  include ClassUnderTest
  include MockEnv

  attr_reader :json, :source

  def setup
    @class_under_test = ProjectTemplates::Sources::EnvFile
    @source = class_under_test.new("SOME_ENV")
  end

  def test_has_a_description
    assert_equal(
      "Returns a dictionary from a file containing YAML or JSON pointed at by an environment variable.",
      class_under_test::DESCRIPTION
    )
  end

  def test_not_loadable_when_env_is_unset
    mock_env(delete: "SOME_ENV") do
      refute_predicate(source, :loadable?)
    end
  end

  def test_loadable_when_env_is_set
    mock_env(SOME_ENV: "/etc/hosts") do
      assert_predicate(source, :loadable?)
    end
  end

  def test_loads_nil_on_unparsable_string
    mock_env(SOME_ENV: "/etc/hosts") do
      assert_raises(ArgumentError) { source.load }
    end
    assert_nil(source.dictionary)
  end

  def test_loads_a_dictionary_from_a_string
    mock_env(SOME_ENV: "/etc/hosts") do
      source.load
    end
    # assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
  end
end
