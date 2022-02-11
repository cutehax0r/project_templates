# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # A wrapper class that considers multiple sources for variables
  # and exposes the 'final computed result'.
  class ConfigVariables
    extend T::Sig
  end
end
