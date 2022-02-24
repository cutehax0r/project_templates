# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class List
      include Action
      def check_requirements
        return true if template_path.readable?

        @errors << "Cannot read templates path #{config.path_templates}"
      end

      def perform_action
        Dir.glob("*/", base: template_path).each { puts _1[...-1] }
      end

      private

      def template_path
        @template_path ||= Pathname.new(config.path_templates).expand_path
      end
    end
  end
end
