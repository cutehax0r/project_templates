# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # do all the work
  class App
    extend T::Sig

    sig { params(args: T.untyped, parser: T.untyped, actions: T.untyped).returns(T.attached_class) }
    def self.configure(args = ARGV, parser: Config, actions: Actions)
      config = parser.parse(args)
      new(config, actions: actions)
    end

    sig { params(config: T.untyped, actions: T.untyped).void }
    def initialize(config, actions: Actions)
      @config = config
      @actions = actions
    end

    sig { void }
    def run
      action = @actions.const_get(@config.action.to_s.capitalize.to_sym).new(@config)
      action.run
      puts action.errors if action.failure?
    end
  end
end
