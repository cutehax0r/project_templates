# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

require_relative "project_templates/app"
require_relative "project_templates/version"

module ProjectTemplates
  extend T::Sig
end
