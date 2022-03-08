# frozen_string_literal: true
# typed: strict

require "optparse"
require "sorbet-runtime"

module ProjectTemplates
  class Config
    extend T::Sig

    sig { params(args: T::Array[String]).returns(T.attached_class) }
    # given argv, parse that into a config
    def self.parse(args)
      opts = {}
      project, target = option_parser.parse!(args, into: opts)
      new(
        project: project.to_s, target: target.to_s,
        action: set_action(project, target, opts),
        path_working: opts[:path_working].to_s,
        path_templates: opts[:path_templates].to_s,
        path_target: opts[:path_target].to_s,
        path_project: opts[:path_project].to_s,
        variables: opts[:variables].to_s
      )
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption => e
      puts e.message
      exit(1)
    end

    sig { params(project: T.untyped, target: T.untyped, opts: T.untyped).returns(Symbol) }
    def self.set_action(project, target, opts)
      return :help if opts[:help]
      return :version if opts[:version]
      return :list if opts[:list]
      return :create if project && target

      :help
    end

    sig { returns(OptionParser) }
    def self.option_parser
      OptionParser.new do |opts|
        opts.banner = "Usage: project_templates project template [options]"
        opts.on("-h", "--help", "print help")
        opts.on("--version", "print version help")
        opts.on("-l", "--list", "show all templates")
        opts.on("-tPATH", "--path_templates=PATH", "path to templates")
        opts.on("-pPATH", "--path_project=PATH", "path to projet")
        opts.on("-oPATH", "--path_target=PATH", "path to target")
        opts.on("-wPATH", "--path_working=PATH", "path to working directory")
        opts.on("-vVARS", "--variables=VARS", "variables as json")
      end
    end

    sig { returns(String) }
    # name of the template to use
    attr_accessor :project

    sig { returns(String) }
    # name of the new templated project
    attr_accessor :target

    sig { returns(Symbol) }
    # the action
    attr_accessor :action

    sig { returns(String) }
    # the path to templates
    attr_accessor :path_templates

    sig { returns(String) }
    # the path to write to
    attr_accessor :path_target

    sig { returns(String) }
    # the path to read from
    attr_accessor :path_project

    sig { returns(String) }
    # the path to templates
    attr_accessor :path_working

    sig { returns(String) }
    # the variables
    attr_accessor :variables

    sig do
      params(
        project: String,
        target: String,
        action: Symbol,
        path_templates: String,
        path_target: String,
        path_project: String,
        path_working: String,
        variables: String
      ).void
    end
    # do the init
    def initialize(project:, target:, action:, path_templates:, path_target:, path_project:, path_working:, variables:) # rubocop:disable Metrics/ParameterLists
      @project = project
      @target = target
      @action = action
      @path_templates = path_templates
      @path_target = path_target
      @path_project = path_project
      @path_working = path_working
      @variables = variables
    end

    def bind
      binding
    end
  end
end
