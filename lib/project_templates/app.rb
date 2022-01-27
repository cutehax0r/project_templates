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
      puts "Hello"
    end
  end
end
