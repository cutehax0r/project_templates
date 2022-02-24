# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # This is a wrapper class that contains pointers to all of the
  # important paths used by the application.
  class ConfigPaths
    extend T::Sig

    # Maybe these should be lambdas so they resolve at run time not parse time
    DEFAULT_TEMPLATE = T.let(Pathname.new("~/.share/project_templates").expand_path, Pathname)
    DEFAULT_WORKING = T.let(Pathname.new(Dir.pwd).expand_path, Pathname)

    sig do
      params(
        project: T.nilable(String),
        target: T.nilable(String),
        template_path: String,
        working_path: String
      ).void
    end
    # initializes the paths used in the config. By default paths will be
    # expanded. if a path is provided it will expanded to an absolute one.
    def initialize(
      project: nil,
      target: nil,
      template_path: DEFAULT_TEMPLATE.to_s,
      working_path: DEFAULT_WORKING.to_s
    )
      @project_name = project
      @target_name = target
      @template_path = T.let(Pathname.new(template_path).expand_path, Pathname)
      @working_path = T.let(Pathname.new(working_path).expand_path, Pathname)
      @errors = T.let([], T::Array[String])
      valid?
    end

    sig { returns(T::Boolean) }
    # are all the paths valid readable / writable locations?
    def valid?
      # handle nil project and template
      @errors.clear
      @errors << "template path cannot be read" unless @template_path&.readable?
      @errors << "project path cannot be read" unless @project_path&.readable?
      @errors << "working directory cannot be written" unless @working_path&.writable?
      @errors << "target directory already exists" if @target_path&.writable?
      @errors.empty?
    end

    sig { returns(T::Array[String]) }
    # Errors that happen after validation
    attr_reader :errors

    sig { returns(String) }
    # that path where templates can be found
    def template_path
      @template_path.to_s
    end

    sig { returns(String) }
    # the path to where the project template can be found
    def project_path
      T.let(@template_path.join(project_name).expand_path, Pathname).to_s
    end

    sig { returns(String) }
    # the path where the target for the project template will be built
    def working_path
      @working_path.to_s
    end

    sig { returns(String) }
    # the path to where the project template will be built
    def target_path
      T.let(@working.join(target_name).expand_path, Pathname).to_s
    end
  end
end
