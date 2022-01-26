# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  class Dictionary
    extend T::Sig

    sig { void }
    def initialize; end
  end
end
