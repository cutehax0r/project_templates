# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  class App
    extend T::Sig

    sig { void }
    # The main entry point of the application. Instantiate the application
    # passing arguments and then call "run" to make it work. Execution
    # options can be set before calling run in order to configure the
    # application.
    def run
      puts "Hello"
    end
  end
end
