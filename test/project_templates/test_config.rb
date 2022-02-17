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
      variables: ProjectTemplates::ConfigVariables.new,
      paths: ProjectTemplates::ConfigPaths.new(project_name: "project", target_name: "target"),
    }

    @config = class_under_test.new(**args)
  end

  test_has_attribute(:config, :project, readable: true, writable: true)
  test_has_attribute(:config, :target, readable: true, writable: true)
  test_has_attribute(:config, :paths, readable: true, writable: true)
  test_has_attribute(:config, :variables, readable: true, writable: true)

  # vars maps to variables.dictionary

  def test_initialize_can_be_provided_all_arguments
    # mocking and #== don't play well together
    args.each do |argument, expected_value|
      assert_equal expected_value, config.send(argument)
    end
  end
end
