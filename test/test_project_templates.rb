# frozen_string_literal: true

require "test_helper"

class TestProjectTemplates < MiniTest::Test
  def test_it_has_a_version
    refute_nil ProjectTemplates::VERSION
  end
end
