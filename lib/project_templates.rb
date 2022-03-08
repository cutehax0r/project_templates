# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

require_relative "project_templates/app"
require_relative "project_templates/config"
require_relative "project_templates/template"
require_relative "project_templates/version"
require_relative "project_templates/actions/action"
require_relative "project_templates/actions/create"
require_relative "project_templates/actions/help"
require_relative "project_templates/actions/list"
require_relative "project_templates/actions/version"

module ProjectTemplates
  extend T::Sig
end
