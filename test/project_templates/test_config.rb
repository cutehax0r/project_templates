# frozen_string_literal: true

require "test_helper"

class TestConfig < MiniTest::Test
  extend HasAttributeHelper

  attr_reader :config, :class_under_test

  def setup
    @class_under_test = ProjectTemplates::Config
    @config = class_under_test.new
  end

  test_has_attribute(:config, :dry_run, readable: true, writable: true, interrogatable: true)
  test_has_attribute(:config, :template_path, readable: true, writable: true)
  test_has_attribute(:config, :project_path, readable: true, writable: true)
  test_has_attribute(:config, :target_path, readable: true, writable: true)
  test_has_attribute(:config, :working_path, readable: true, writable: true)
  test_has_attribute(:config, :project_name, readable: true, writable: true)
  test_has_attribute(:config, :target_name, readable: true, writable: true)

  def test_defines_default_constants
    assert_equal(Pathname.new("~").expand_path, class_under_test::DEFAULT_TEMPLATE_PATH)
    assert_equal(Pathname.new("~").expand_path, class_under_test::DEFAULT_PROJECT_PATH)
    assert_equal(Pathname.new(Dir.pwd).expand_path, class_under_test::DEFAULT_TARGET_PATH)
    assert_equal(Pathname.new(Dir.pwd).expand_path, class_under_test::DEFAULT_WORKING_PATH)
    assert_equal("target", class_under_test::DEFAULT_TARGET_NAME)
    assert_equal("project", class_under_test::DEFAULT_PROJECT_NAME)
  end

  def test_initialize_uses_defaults
    refute(config.dry_run?)
    assert_equal(class_under_test::DEFAULT_TEMPLATE_PATH, config.template_path)
    assert_equal(class_under_test::DEFAULT_PROJECT_PATH, config.project_path)
    assert_equal(class_under_test::DEFAULT_TARGET_PATH, config.target_path)
  end

  def test_initialize_can_be_provided_all_arguments
    args = {
      dry_run: true,
      template_path: Pathname.new("/").expand_path,
      project_path: Pathname.new("/").expand_path,
      target_path: Pathname.new("/").expand_path,
      working_path: Pathname.new("/").expand_path,
      project_name: "new_project",
      target_name: "some_target",
    }
    inited_config = class_under_test.new(**args)
    args.each do |argument, expected_value|
      assert_equal expected_value, inited_config.send(argument)
    end
  end
end
