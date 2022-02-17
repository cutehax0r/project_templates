# frozen_string_literal: true

require "test_helper"

class TestApp < MiniTest::Test
  include ClassUnderTest
  attr_reader :app

  def setup
    config = ProjectTemplates::Config.new(
      project: "foo",
      target: "bar",
      variables: ProjectTemplates::ConfigVariables.new,
      paths: ProjectTemplates::ConfigPaths.new(project_name: "foo", target_name: "bar")
    )
    @app = class_under_test.new(config)
  end

  def test_can_be_run
    assert_respond_to(app, :run)
  end

  def test_prints_hello
    assert_output(/Hello/) { app.run }
  end
end
