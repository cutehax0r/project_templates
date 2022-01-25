# frozen_string_literal: true

require "test_helper"

class TestConfig < MiniTest::Test
  attr_reader :config

  def setup
    @config = ProjectTemplates::Config.new
  end

  def test_initializes_dry_run_to_false_by_default
    refute config.dry_run?
  end

  def test_it_initializes_dry_run
    config = ProjectTemplates::Config.new(dry_run: true)
    assert config.dry_run?
  end

  def test_has_a_dry_run_method
    assert_respond_to config, :dry_run?
    assert_respond_to config, :dry_run
  end
end
