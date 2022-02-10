# frozen_string_literal: true

require "test_helper"

class TestEnvString < MiniTest::Test
  include ClassUnderTest
  include MockEnv

  attr_reader :json, :source

  def setup
    @source = class_under_test.new("SOME_ENV")
  end

  def test_has_a_description
    assert_equal(
      "Returns a dictionary from a string taken from an environment variable containing YAML or JSON.",
      class_under_test::DESCRIPTION
    )
  end

  def test_not_loadable_when_env_is_unset
    mock_env(delete: "SOME_ENV") do
      refute_predicate(source, :loadable?)
    end
  end

  def test_loadable_when_env_is_set
    mock_env(SOME_ENV: :foo) do
      assert_predicate(source, :loadable?)
    end
  end

  def test_loads_nil_on_unparsable_string
    mock_env(SOME_ENV: "foo") { source.load }
    assert_nil(source.dictionary)
  end

  def test_loads_a_dictionary_from_a_string
    mock_env(SOME_ENV: { foo: :bar }.to_json) do
      source.load
    end
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
    # assert parsed json
  end
end
