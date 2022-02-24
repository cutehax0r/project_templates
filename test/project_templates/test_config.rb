# frozen_string_literal: true

require "test_helper"

class TestConfig < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :args, :config

  def setup
    @args = {
      project: "project",
      target: "target",
      action: :help,
      path_templates: "",
      path_project: "",
      path_target: "",
      variables: "",
    }

    @config = class_under_test.new(**args)
  end

  test_has_attribute(:config, :project, readable: true, writable: true)
  test_has_attribute(:config, :target, readable: true, writable: true)
end
