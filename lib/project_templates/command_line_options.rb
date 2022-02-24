# frozen_string_literal: true
# typed: false

require "optparse"
require "sorbet-runtime"

module ProjectTemplates
  class CommandLineOptions
    extend T::Sig

    attr_reader :opts

    class << self
      extend T::Sig

      def parse # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        arguments = {}
        parser = OptionParser.new do |p|
          p.banner = "Project Templates"
          p.separator("")
          p.on("-h", "--help", nil, "Show the help")
          p.on("-v", "--version", nil, "Display the version")
          p.on("-k", "--health-check", nil, "Check the application configuration")
          p.on("-l", "--list", nil, "Show all createable projects")
          p.on("-y", "--verify", nil, "Perform all actions that don't modify the file system")
          p.on("-n", "--no-scripts", nil, "Don't run any scripts defined in the project")
          p.on("-fFILE", "--file=FILE", String, "Path to config file")
          p.on("-tTEMPLATES", "--templates=TEMPLATES", String, "Path to template directory")
          p.on("-wWORKING", "--working=WORKING", String, "Path to create new project in")
          p.on("-pPROJECT", "--project=PROJECT", String, "Path to specific project template")
          p.on("-dDESTINATION", "--destination=DESTINATION", String, "Path for target directory of new project")
          p.on("-a", "--variables", String, "Variables that override global config")
        end
        project, target = parser.parse!(into: arguments)
        arguments[:project] = project
        arguments[:target] = target
        arguments[:action] = action_for_opts(arguments)
        new(**arguments)
      end

      def action_for_opts(opts)
        return :help if opts[:target].nil? || opts[:project].nil? || opts[:help]
        return :version if opts[:version]
        return :health_check if opts[:health_check]
        return :list if opts[:list]
        return :verify if opts[:verify]

        :create_project
      end
    end

    def initialize(**opts)
      # so this is basically the config loader.
      # parse the options then switch on 'action'
      # short circuit run:
      # - verion: print version and exit
      # - help: print help and exit
      # - health: load config, print details about env, templates, paths, etc.
      # full run
      # - list: load config, list content of `templates_path`
      # - verify: load config, load project, 'render' templates to a string, print 'unsatisfied variables',
      #   template content, directory status, scripts
      # - run: perform verify, if no issues, write templates out to target files, run scripts
      @opts = opts
    end
  end
end
