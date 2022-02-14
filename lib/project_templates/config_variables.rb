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
      @project = T.let(project || default, Dictionary)
      @global = T.let(global || default, Dictionary)
      @run = T.let(run || default, Dictionary)
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
    # applies the overriding rules.
    def dictionary
      @dictionary ||= begin
        dictionary_sum project.to_h.merge(global.to_h).merge(run.to_h)
        Dictionary.new(dictionary_sum)
      end
    end
  end
end
