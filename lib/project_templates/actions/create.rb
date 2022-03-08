# frozen_string_literal: true

module ProjectTemplates
  module Actions
    class Create
      include Action
      def check_requirements
        @errors << "Could not read project directory" unless path_project.readable?
        @errors << "Project directory does not contain templates" unless path_project_template.readable?
        @errors << "Working directory not writable" unless path_working.writable?
        @errors << "Target directory already exists" if path_target.exist?
      end

      def perform_action
        puts "create the project template"
        require "pry"
        files = path_project_template.glob("**/*", File::FNM_DOTMATCH).map { Template.new(_1, config: @config) }
        files.each(&:process)
        # read things form templates/
        # for each thing instantiate "file"
        #   template(config:, permissions:, source:, content:, target:, output:, errors:)
        # for each file 'render' template
        # check all target paths could be created
        # if no errors write content to target
        # copy permissions over
        # run 'shell script' from config.yaml
      end

      private

      def path_project_template
        @path_project_template ||= Pathname.new(config.path_project).expand_path.join("./templates")
      end

      def path_project
        @path_project ||= Pathname.new(config.path_project).expand_path
      end

      def path_working
        @path_working ||= Pathname.new(config.path_working).expand_path
      end

      def path_target
        @path_target ||= Pathname.new(config.path_target).expand_path
      end
    end
  end
end
