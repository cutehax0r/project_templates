# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class Create
      include Action
      def check_conditions
        # nothing to check
      end

      def perform_action
        puts "create the project template"
      end
    end
  end
end
