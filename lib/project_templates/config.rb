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

    sig { returns(T::Boolean) }
    # When dry-run is true no changes to the file system will be made but
    # all other steps will be completed. Access to the target path will be
    # verified and all other compilation steps will complete.
    attr_accessor :dry_run

    # attr_reader :user_path, :project_path, :template_path, :target_path, :template_name, :target_name,
    #             :user_variables, :project_variables

    sig { params(dry_run: T::Boolean).void }
    # Initialize a config by explicitly setting all of the values. If you
    # don't want to set all values consider using one of the class methods
    # instead.
    def initialize(dry_run: false)
      @dry_run = dry_run
    end

    alias dry_run? dry_run
  end
end
