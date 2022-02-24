# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class List
      include Action
      def check_conditions
        # nothing to check
      end

      def perform_action
        puts "list the content of config.path_templates"
      end
    end
  end
end
