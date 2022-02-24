# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # This responsible for doing all the work of the application. Once
  # configured you run the application and it'll run according to the
  # configuration. Note that there is going to be a separate CLIApplication
  # class that handles setting-up the application and running it. That CLI
  # will handle command line argument parsing displaying help, etc. This is
  # so that the App class can be used by a graphical interface or even a
  # web-app in the future.
  class App
    extend T::Sig

    class << self
      extend T::Sig
      # Given a set of configuration parameters, ARGV style, setup the
      # application configuration ready to run.
      sig { params(args: T::Array[String]).returns(T.attached_class) }
      def configure(args)
        @args = args
        opts = CommandLineOptions.parse
        project = opts.opts.fetch(:project)
        target = opts.opts.fetch(:target)

        variables = ConfigVariables.new
        paths = ConfigPaths.new(project: project, target: target)
        config = ProjectTemplates::Config.new(project:, target:, variables:, paths:, action: opts.opts[:action])
        new(config)
      end
    end

    sig { returns(Config) }
    # the global application configuration
    attr_reader :config

    sig { params(config: Config).void }
    # Setup a config argument with paths and variables. Pass that to the
    # initializer. Once that's done you can call "run".
    def initialize(config)
      @config = config
    end

    sig { void }
    # The main entry point of the application. Instantiate the application
    # passing arguments and then call "run" to make it work. Execution
    # options can be set before calling run in order to configure the
    # application.
    # The configuration will be checked and verified and then a new project
    # will be created.
    def run
      # each of these should become a 'task' class that actually
      # does the work, but for now we can just do them as instance methods
      send(config.action)
    end

    private

    sig { void }
    # prints the application version
    def version
      puts VERSION
    end

    sig { void }
    # Prints the application command line help
    def help
      puts "IOU a puts parser.to_s"
    end

    sig { void }
    # verify the application configuration
    def health_check
      puts "Print the 'status' of the application configuration"
    end

    sig { void }
    # list all theprojects
    def list
      puts "list all the projects"
    end

    sig { void }
    # verify the template processing but don't change the file system
    def verify
      puts "IOU a verify run"
    end

    sig { void }
    # create the project using the template
    def create_project
      puts "This should actually do all the work"
    end
  end
end
