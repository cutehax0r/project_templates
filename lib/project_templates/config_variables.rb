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
        project_variables: T.nilable(Dictionary),
        global_variables: T.nilable(Dictionary),
        run_variables: T.nilable(Dictionary)
      ).void
    end
    # Pass in the three sets of variables and this will give you back a
    # dictionary with all of the overrides applied:
    #   * project variables are less important than
    #   * global variables are less important than
    #   * run variables
    def initialize(
      project_variables: nil,
      global_variables: nil,
      run_variables: nil
    )
      default_dictionary = DEFAULT_DICTIONARY_LOADER.new.load
      @project_variables = project_variables || default_dictionary
      @global_variables = global_variables || default_dictionary
      @run_variables = run_variables || default_dictionary
    end
  end
end
