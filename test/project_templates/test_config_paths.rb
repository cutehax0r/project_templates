# frozen_string_literal: true

require "test_helper"

class TestConfigPaths < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :paths

  def setup
    @paths = class_under_test.new
  end
end
