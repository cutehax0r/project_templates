# frozen_string_literal: true
# typed: strict

require "json"
require "yaml"
require "sorbet-runtime"

module ProjectTemplates
  module Sources
    class String
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a string that can be parsed as JSON or YAML."

      sig { override.returns(T::Boolean) }
      # string sources are always loadable.
      def loadable?
        true
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the provided string
      def load_source
        Dictionary.load(@source)
      end
    end
  end
end
