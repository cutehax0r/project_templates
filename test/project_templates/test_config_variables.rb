# frozen_string_literal: true

require "test_helper"

class TestConfigVariables < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :vars

  def setup
    @vars = class_under_test.new
  end

  # has reader for project global run and dictionary
  # init takes project global and run
  # init defaults are empty dictionaries
  # dictionary has global override project
  # dictionary has run override global
  # dictionary has run override project
end
