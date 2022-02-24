# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class Help
      include Action
      def check_requirements
        # nothing to check
      end

      def perform_action
        puts config.class.option_parser.to_s
      end
    end
  end
end
