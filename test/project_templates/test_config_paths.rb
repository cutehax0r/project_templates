# frozen_string_literal: true

require "test_helper"

class TestConfigPaths < MiniTest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_reader :paths

  def setup
    @paths = class_under_test.new
  end

  # has readers for
  # errors, template, working, project, target

  # default working is sane
  # default target is sane

  # has valid? that verifies things:
  # * template path is not readable
  # * project path is not readable
  # * working directory not writable
  # * target path exists

  # init takes project name, target name, working dir and templates dir
  # init defaults are from defaults consts

  # init computes target and project dir

  # allow override of target dir
  # allow override of project dir
end
