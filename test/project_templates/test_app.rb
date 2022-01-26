# frozen_string_literal: true

require "test_helper"

class TestApp < MiniTest::Test
  attr_reader :app

  def setup
    @app = ProjectTemplates::App.new
  end

  def test_can_be_run
    assert_respond_to(app, :run)
  end

  def test_can_be_initialized_with_a_config
    config = MiniTest::Mock.new(ProjectTemplates::Config.new)
    ProjectTemplates::App.new(config)
  end

  def test_prints_hello
    assert_output(/Hello/) { app.run }
  end
end
