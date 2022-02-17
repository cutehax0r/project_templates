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

    DEFAULT_TEMPLATE_PATH = T.let(Pathname.new("~").expand_path, Pathname)
    DEFAULT_PROJECT_PATH = T.let(Pathname.new("~").expand_path, Pathname)
    DEFAULT_TARGET_PATH = T.let(Pathname.new(Dir.pwd).expand_path, Pathname)
    DEFAULT_WORKING_PATH = T.let(Pathname.new(Dir.pwd).expand_path, Pathname)
    DEFAULT_TARGET_NAME = T.let("target", String)
    DEFAULT_PROJECT_NAME = T.let("project", String)
    DEFAULT_DICTIONARY = T.let(Dictionary.load("{}"), Dictionary)

    sig { returns(T::Boolean) }
    # When dry-run is true no changes to the file system will be made but
    # all other steps will be completed. Access to the target path will be
    # verified and all other compilation steps will complete.
    attr_accessor :dry_run
    alias dry_run? dry_run

    sig { returns(Pathname) }
    # The path where template projects are located. This is the path where
    # the project_path is expected to be
    attr_accessor :template_path

    sig { returns(Pathname) }
    # The path which will be used as the "source" for creating the new project
    # by default this would be located within #template_path and is computed by
    # joining project_name to template_path.
    attr_accessor :project_path

    sig { returns(Pathname) }
    # The path which will be created by copying files from the project_path to
    # this location. The is computed by appending target_name to the current
    # working directory
    attr_accessor :target_path

    sig { returns(Pathname) }
    # The working directory, where the new project will be created. Defaults to
    # the current working directory.
    attr_accessor :working_path

    sig { returns(String) }
    # The name of the target. Appended to the end of working directory to form
    # target_path.
    attr_accessor :target_name

    sig { returns(String) }
    # the name of the project directory to use as a source. Appended to
    # template_path to produce project_path
    attr_accessor :project_name

    sig { returns(Dictionary) }
    # Global variables are read from a configuration file and will override
    # project variables when a conflict occurs. Global variables can in turn be
    # overridden by variables provided at 'run'.
    attr_accessor :global_variables

    sig { returns(Dictionary) }
    # These are variables defined within the project template. They are the
    # lowest level of priority so that you can override variables (e.g. email,
    # copyright holder) by defining them globally once instead of needing to
    # pass overrides on every invocation as command line arguments.
    attr_accessor :project_variables

    sig { returns(Dictionary) }
    # Run variables are the most-specific variables. They override variables
    # defined globally which have in turn overriden variables provided by a
    # project.
    attr_accessor :run_variables

    sig do
      params(
        dry_run: T::Boolean,
        template_path: Pathname,
        project_path: Pathname,
        target_path: Pathname,
        working_path: Pathname,
        project_name: String,
        target_name: String,
        project_variables: Dictionary,
        global_variables: Dictionary,
        run_variables: Dictionary
      ).void
    end
    # Initialize a config by explicitly setting all of the values. If you
    # don't want to set all values consider using one of the class methods
    # instead. Paths and Variables should probably become objects but for
    # now the rubocop rule about param lists will be ignored
    def initialize( # rubocop:disable Metrics/ParameterLists
      dry_run: false,
      template_path: DEFAULT_TEMPLATE_PATH,
      project_path: DEFAULT_PROJECT_PATH,
      target_path: DEFAULT_TARGET_PATH,
      working_path: DEFAULT_TARGET_PATH,
      project_name: DEFAULT_PROJECT_NAME,
      target_name: DEFAULT_TARGET_NAME,
      project_variables: DEFAULT_DICTIONARY,
      global_variables: DEFAULT_DICTIONARY,
      run_variables: DEFAULT_DICTIONARY
    )
      @dry_run = dry_run
      @template_path = template_path
      @project_path = project_path
      @target_path = target_path
      @working_path = working_path
      @project_name = project_name
      @target_name = target_name
      @project_variables = project_variables
      @global_variables = global_variables
      @run_variables = run_variables
    end
  end
end
