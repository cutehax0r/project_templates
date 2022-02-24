# frozen_string_literal: true

require "test_helper"

class TestProjectTemplates < MiniTest::Test
  def test_has_an_app
    refute_nil(ProjectTemplates::App)
  end

  def test_has_a_config
    refute_nil(ProjectTemplates::Config)
  end

  def test_has_a_version
    refute_nil(ProjectTemplates::VERSION)
  end
end
