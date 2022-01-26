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

    sig { returns(T::Boolean) }
    # When dry-run is true no changes to the file system will be made but
    # all other steps will be completed. Access to the target path will be
    # verified and all other compilation steps will complete.
    attr_accessor :dry_run

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

    # TODO: attr_accessor :template_name, :target_name, :user_variables, :project_variables

    sig { params(dry_run: T::Boolean, template_path: Pathname, project_path: Pathname, target_path: Pathname).void }
    # Initialize a config by explicitly setting all of the values. If you
    # don't want to set all values consider using one of the class methods
    # instead.
    def initialize(
      dry_run: false,
      template_path: DEFAULT_TEMPLATE_PATH,
      project_path: DEFAULT_PROJECT_PATH,
      target_path: DEFAULT_TARGET_PATH
    )
      @dry_run = dry_run
      @template_path = T.let(template_path, Pathname)
      @project_path = T.let(project_path, Pathname)
      @target_path = T.let(target_path, Pathname)
    end

    alias dry_run? dry_run
  end
end
