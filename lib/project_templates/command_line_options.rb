# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # Defines command line arguments, parses them into "useful" values
  # and prepares them to be used to create a configuration object
  class CommandLineOptions
    extend T::Sig

    sig { returns(String) }
    # the name of the project that will be created
    attr_accessor :target

    sig { returns(String) }
    # the name of the project that will be used as a template. Directory
    # relataive to templates_directory
    attr_accessor :project

    sig { returns(String) }
    # path to the config file to use for global options
    attr_accessor :config_file

    sig { returns(String) }
    # path to the create the project in
    attr_accessor :working_directory

    sig { returns(String) }
    # path to the create the project in
    attr_accessor :template_directory

    sig { returns(String) }
    # path to use for project directory. Used in place of computed one inside
    # of target_directory
    attr_accessor :project_directory

    sig { returns(String) }
    # path to use for for created project. Used in place of computed one
    # inside of working_directory
    attr_accessor :target_directory

    sig { returns(String) }
    # explicitly provided variables
    attr_accessor :variables

    sig { returns(String) }
    # Action for the application to take - should probably be an enum
    attr_accessor :action

    sig { void }
    def initialize
      @target = ""
      @project = ""
      @config_file = ""
      @working_directory = ""
      @template_directory = ""
      @project_directory = ""
      @target_directory = ""
      @variables = ""
      @action = ""
    end

    sig { params(_arguments: T::Array[String]).void }
    def parse(_arguments)

    end

    sig { params(parser: OptionParser).void }
    def define_parser(parser)
      parser.banner("Project Templates")
      parser.separator("")
      # methods to define each thing go here
      parser.separator("Specific Options:")
      parser.separator("")
      parser.separator("Common Options:")
      # methods to define common things go here
    end
  end
end
