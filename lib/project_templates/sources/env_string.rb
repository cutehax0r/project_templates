# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    class EnvString
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a string taken from an environment variable containing YAML or JSON."

      sig { override.returns(T::Boolean) }
      # ensures the source points to a file which exists and is readable
      def loadable?
        ENV.key?(source)
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the empty hash
      def load_source
        Dictionary.load(ENV.fetch(source))
      end
    end
  end
end
