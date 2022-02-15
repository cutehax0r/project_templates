# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # A wrapper class that considers multiple sources for variables
  # and exposes the 'final computed result'.
  class ConfigVariables
    extend T::Sig

    sig do
      params(
        project: T.nilable(Dictionary),
        global: T.nilable(Dictionary),
        run: T.nilable(Dictionary)
      ).void
    end
    # Pass in the three sets of variables and this will give you back a
    # dictionary with all of the overrides applied:
    #   * project variables are less important than
    #   * global variables are less important than
    #   * run variables
    def initialize(
      project: nil,
      global: nil,
      run: nil
    )
      default = Sources::Empty.new.load
      @project = T.let(T.must(project || default), Dictionary)
      @global = T.let(T.must(global || default), Dictionary)
      @run = T.let(T.must(run || default), Dictionary)
      @dictionary = T.let(build_dictionary, Dictionary)
    end

    sig { returns(Dictionary) }
    # the lowest level variables
    attr_accessor :project

    sig { returns(Dictionary) }
    # the medium level variables
    attr_accessor :global

    sig { returns(Dictionary) }
    # the highest level variables
    attr_accessor :run

    sig { returns(Dictionary) }
    # the aggregate dictionary
    attr_accessor :dictionary

    private

    sig { returns(Dictionary) }
    # does the work of building a dictionary from run, project, and global variables
    def build_dictionary
      # pro glob run
      @global.to_h.merge(@global.to_h)
      @global
    end
  end
end
