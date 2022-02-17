# frozen_string_literal: true

require "test_helper"

class TestConfigPaths < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :paths

  def setup
    @paths = class_under_test.new(
      target_name: "target",
      project_name: "project"
    )
  end

  test_has_attribute(:paths, :errors, readable: true)
  test_has_attribute(:paths, :project, readable: true)
  test_has_attribute(:paths, :target, readable: true)
  test_has_attribute(:paths, :template, readable: true)
  test_has_attribute(:paths, :valid, interrogatable: true)
  test_has_attribute(:paths, :working, readable: true)

  def test_defines_default_constants
    assert_equal(Pathname.new("~/.share/project_templates").expand_path.to_s, class_under_test::DEFAULT_TEMPLATE.to_s)
    assert_equal(Pathname.new(Dir.pwd).expand_path.to_s, class_under_test::DEFAULT_WORKING.to_s)
  end

  def test_init_uses_defaults_with_provided_args
    assert_equal(Pathname.new("~/.share/project_templates").expand_path.to_s, paths.template)
    assert_equal(Pathname.new("~/.share/project_templates/project").expand_path.to_s, paths.project)
    assert_equal(Pathname.new(Dir.pwd).expand_path.to_s, paths.working)
    assert_equal(Pathname.new(Dir.pwd).join("./target").expand_path.to_s, paths.target)
  end

  def test_init_allows_override_of_default_paths
    paths_init = class_under_test.new(
      project_name: "project",
      target_name: "target",
      template_path: "/templates",
      working_path: "/src"
    )
    assert_equal("/templates", paths_init.template)
    assert_equal("/templates/project", paths_init.project)
    assert_equal("/src/target", paths_init.target)
    assert_equal("/src", paths_init.working)
  end

  def test_erorrs_starts_empty
    dir("/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").to_s,
        project_name: "project",
        target_name: "target"
      )
      assert_predicate(paths_init.errors, :empty?)
      assert_predicate(paths_init, :valid?)
    end
  end

  def test_allows_explicit_customization_of_project_dir
    # TODO: make an attr_writer for project
    skip "not yet implemented"
    dir("/templates/custom_project", "/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").expand_path.to_s,
        project_name: "project",
        target_name: "target"
      )
      paths_init.project = template.join("./custom_project").to_s
      assert_predicate(paths_init, :valid?)
    end
  end

  def test_allows_explicit_customization_of_target_dir
    # TODO: make an attr_writer for target
    skip "not yet implemented"
    dir("/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").expand_path.to_s,
        project_name: "project",
        target_name: "target"
      )
      paths_init.target = Pathname.new(Dir.pwd).join("./foo/bar/baz").expand_path
      assert_predicate(paths_init, :valid?)
    end
  end

  def test_allows_explicit_customization_of_working_dir
    # TODO: make an attr_writer for working
    skip "not yet implemented"
    dir("/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").expand_path.to_s,
        project_name: "project",
        target_name: "target"
      )
      paths_init.working = Pathname.new(Dir.pwd).join("./foo/bar/baz").expand_path
      assert_predicate(paths_init, :valid?)
    end
  end

  def test_valid_fails_on_missing_template_directiory
    dir("/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./not_exist").to_s,
        project_name: "project",
        target_name: "target"
      )
      assert_includes(paths_init.errors, "template path cannot be read")
    end
  end

  def test_valid_fails_on_unreadable_project_directiory
    dir("/templates/project") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).to_s,
        project_name: "not_exist",
        target_name: "target"
      )
      assert_includes(paths_init.errors, "project path cannot be read")
    end
  end

  def test_valid_fails_on_existing_target_directiory
    dir("/templates/project", "/target") do
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").to_s,
        working_path: Pathname.new(Dir.pwd).to_s,
        project_name: "project",
        target_name: "target"
      )
      assert_includes(paths_init.errors, "target directory already exists")
    end
  end

  def test_valid_fails_on_unwritable_working_directiory
    dir("/templates/project", "/projects") do
      working_path = Pathname.new(Dir.pwd).join("./projects")
      working_path.lchmod(0o544)
      paths_init = class_under_test.new(
        template_path: Pathname.new(Dir.pwd).join("./templates").to_s,
        working_path: working_path.to_s,
        project_name: "project",
        target_name: "target"
      )
      assert_includes(paths_init.errors, "working directory cannot be written")
      working_path.lchmod(0o744)
    end
  end

  private

  def dir(*paths, &block)
    Dir.mktmpdir do |dir|
      Dir.chdir dir do
        paths.each { Pathname.new(Dir.pwd).join(".#{_1}").mkpath }
        yield(block)
      end
    end
  end
end
