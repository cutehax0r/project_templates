# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

require_relative "project_templates/app"
require_relative "project_templates/dictionary"
require_relative "project_templates/dictionary_source"
require_relative "project_templates/sources/empty"
require_relative "project_templates/sources/file"
require_relative "project_templates/sources/string"
require_relative "project_templates/sources/env_string"
require_relative "project_templates/sources/env_file"
require_relative "project_templates/config"
require_relative "project_templates/version"

module ProjectTemplates
  extend T::Sig
end
