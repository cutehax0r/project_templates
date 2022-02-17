# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # Provides all of the unique configuration for the application. The
  # attributes allow both getting and setting of configuration values so
  # that a Configuration can be built "on the fly" Class methods to
  # instantiate a configuration using defaults simplify getting a config
  # ready to use.
  class Config
    extend T::Sig

    sig { returns(String) }
    # name of the template to use
    attr_accessor :project

    sig { returns(String) }
    # name of the new templated project
    attr_accessor :target

    sig { returns(ConfigVariables) }
    # a container for all of the variable sets
    attr_accessor :variables

    sig { returns(ConfigPaths) }
    # a container holding all the important paths
    attr_accessor :paths

    sig do
      params(
        project: String,
        target: String,
        paths: ConfigPaths,
        variables: ConfigVariables
      ).void
    end
    # Initialize a config by explicitly setting all of the values. If you
    # don't want to set all values consider using one of the class methods
    # instead. Paths and Variables should probably become objects but for
    # now the rubocop rule about param lists will be ignored
    def initialize(project:, target:, paths:, variables:)
      @project = project
      @target = target
      @paths = paths
      @variables = variables
    end

    sig { returns(Dictionary) }
    # expose the computed dictionary of variables at a convenient location
    def vars
      variables.dictionary
    end
  end
end
