# frozen_string_literal: true

require "test_helper"

class TestConfigVariables < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :vars

  def setup
    @vars = class_under_test.new
  end

  test_has_attribute(:vars, :dictionary, readable: true)
  test_has_attribute(:vars, :global, readable: true)
  test_has_attribute(:vars, :project, readable: true)
  test_has_attribute(:vars, :run, readable: true)

  def test_initializes_with_empty_dictionaries
    assert_equal({}, vars.global.to_h)
    assert_equal({}, vars.project.to_h)
    assert_equal({}, vars.run.to_h)
  end

  def test_initializes_with_provided_dictionaries
    vars_init = class_under_test.new(
      global: dict(foo: 1),
      project: dict(foo: 2),
      run: dict(foo: 3)
    )
    assert_equal({ foo: 1 }, vars_init.global.to_h)
    assert_equal({ foo: 2 }, vars_init.project.to_h)
    assert_equal({ foo: 3 }, vars_init.run.to_h)
  end

  def test_dictionary_overrides_project_with_global_and_global_with_run
    vars_dict = class_under_test.new(
      global: dict(bar: 2, baz: 2),
      project: dict(foo: 1, bar: 1, baz: 1),
      run: dict(baz: 3)
    ).dictionary
    assert_equal(1, vars_dict.foo)
    assert_equal(2, vars_dict.bar)
    assert_equal(3, vars_dict.baz)
  end

  private

  def dict(**values)
    ProjectTemplates::Dictionary.load(values.to_json)
  end
end
