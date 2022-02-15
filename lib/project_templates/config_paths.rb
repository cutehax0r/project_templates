# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # This is a wrapper class that contains pointers to all of the
  # important paths used by the application.
  class ConfigPaths
    extend T::Sig

    DEFAULT_TEMPLATE = T.let(Pathname.new("~/.share/project_templates/").expand_path, Pathname)
    DEFAULT_WORKING = T.let(Pathname.new(Dir.pwd).expand_path, Pathname)

    sig do
      params(
        project_name: String,
        target_name: String,
        template_path: String,
        working_path: String
      ).void
    end
    # initializes the paths used in the config. By default paths will be
    # expanded. if a path is provided it will expanded to an absolute one.
    def initialize(
      project_name:,
      target_name:,
      template_path: DEFAULT_TEMPLATE.to_s,
      working_path: DEFAULT_WORKING.to_s
    )
      @project_name = project_name
      @target_name = target_name
      @template = T.let(Pathname.new(template_path).expand_path, Pathname)
      @working = T.let(Pathname.new(working_path).expand_path, Pathname)
      @project = T.let(Pathname.new(template).join(project_name).expand_path, Pathname)
      @target = T.let(Pathname.new(working).join(target_name).expand_path, Pathname)
      @errors = T.let([], T::Array[String])
      valid?
    end

    sig { returns(T::Boolean) }
    # are all the paths valid readable / writable locations?
    def valid?
      @errors.clear
      @errors << "template path cannot be read" unless @template.readable?
      @errors << "project path cannot be read" unless @project.readable?
      @errors << "working directory cannot be written" unless @working.writable?
      @errors << "target directory already exists" if @target.writable?
      @errors.any?
    end

    sig { returns(T::Array[String]) }
    # Errors that happen after validation
    attr_reader :errors

    sig { returns(String) }
    # that path where templates can be found
    def template
      @template.to_s
    end

    sig { returns(String) }
    # the path to where the project template can be found
    def project
      @project.to_s
    end

    sig { returns(String) }
    # the path where the target for the project template will be built
    def working
      @working.to_s
    end

    sig { returns(String) }
    # the path to where the project template will be built
    def target
      @target.to_s
    end
  end
end
