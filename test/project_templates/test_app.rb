# frozen_string_literal: true

require "test_helper"

class TestApp < MiniTest::Test
  include ClassUnderTest
  attr_reader :app, :config

  module Action
    class Act
      include ProjectTemplates::Actions::Action
      def check_requirements; end
      def perform_action; end
    end
  end

  def setup
    @config = ProjectTemplates::Config.new(
      project: "",
      target: "",
      action: :act,
      path_templates: "",
      path_project: "",
      path_target: "",
      variables: ""
    )
    @app = class_under_test.new(config, actions: Action)
  end

  def test_can_be_run
    assert_respond_to(app, :run)
  end

  def test_prints_hello_and_exits_success
    app.run
  end
end
