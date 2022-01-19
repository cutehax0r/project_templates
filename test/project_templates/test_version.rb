# frozen_string_literal: true

require "test_helper"

class TestVersion < MiniTest::Test
  def test_declares_a_version
    assert_match(/\d+\.\d+\.\d+/, ProjectTemplates::VERSION)
  end
end
