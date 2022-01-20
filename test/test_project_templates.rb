# frozen_string_literal: true

require "test_helper"

class TestProjectTemplates < MiniTest::Test
  def test_it_has_a_version
    refute_nil ProjectTemplates::VERSION
  end

  def test_it_has_an_app
    refute_nil ProjectTemplates::App
  end
end
