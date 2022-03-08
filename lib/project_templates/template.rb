# frozen_string_literal: true
# typed: strict

require "erb"
require "sorbet-runtime"

module ProjectTemplates
  class Template
    TEMPLATE_EXTENSION = ".erb"
    TEMPLATE_PATH = "templates"
    attr_reader :source, :config

    def initialize(source, config:)
      @source = source
      @config = config
      @errors = []
    end

    def process
      return do_invalid unless valid?

      return do_directory if directory?
      return do_erb if parseable?
      return do_copy unless directory? || parseable?
    end

    def do_invalid
      puts "Invalid template: #{source_file} #{errors}"
    end

    def do_directory
      puts "dir:  #{source_file} => #{target_file}"
    end

    def do_copy
      puts "copy: #{source_file} => #{target_file}"
      # copy a file that doesn't need parsing
    end

    def do_erb
      puts "PARS: #{source_file} => #{target_file}"
    end

    private

    def target_file
      parsed_filename = ERB.new(source_file).result.to_s
      parseable? ? parsed_filename[...-TEMPLATE_EXTENSION.length] : parsed_filename
    end

    def source_file
      Pathname.new(@source).expand_path.relative_path_from(
        Pathname.new(config.path_project).join(TEMPLATE_PATH).expand_path
      ).to_s
    end

    def readable?
      source.readable?
    end

    def parseable?
      Pathname.new(@source).extname == TEMPLATE_EXTENSION
    end

    def writable?
      target.writable
    end

    def directory?
      @source.directory?
    end

    def valid?
      @errors.clear
      # readable
      # writable
      # target_name doesn't crash
      @errors.empty?
    end
  end
end
