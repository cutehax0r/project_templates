# frozen_string_literal: true

require "test_helper"

class TestConfigVariables < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :vars

  def setup
    @vars = class_under_test.new
  end
end
