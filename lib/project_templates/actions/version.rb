# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class Version
      include Action
      def check_conditions
        # nothing to check
      end

      def perform_action
        puts ProjectTemplates::VERSION
      end
    end
  end
end