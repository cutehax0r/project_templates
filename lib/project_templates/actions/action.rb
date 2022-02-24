# frozen_string_literal: true

require "forwardable"

module ProjectTemplates
  module Actions
    module Action
      extend Forwardable
      attr_reader :config, :errors

      def_delegator :@errors, :any?, :failure?
      def_delegator :@errors, :empty?, :success?

      def initialize(config)
        @config = config
        @errors = []
      end

      def check_requirements
        # add to errors if any of the pre-flight conditions fail
      end

      def perform_action
        # do the thing you
      end

      def run
        if valid?
          perform_action
        else
          @errors << "could not run because conditions not met"
        end
      rescue StandardError => e
        @errors << "run failed: #{e}"
      end

      def valid?
        errors.clear
        check_requirements
        errors.empty?
      end
    end
  end
end
