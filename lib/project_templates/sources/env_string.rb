# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    # Works like the String source except that instead of source being a string
    # that is parsed, it is the name of an environment variable that will be read
    # which is expected to contain some YAML or JSON that can be turned into a
    # dictionary. It's a way of adding a layer of indirection to configuration or
    # allowing it to be done via a shell config rather than a file on disc or
    # command line argument. Gracefully handles making sure the environment variable
    # is defined.
    class EnvString
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a string taken from an environment variable containing YAML or JSON."

      sig { override.returns(T::Boolean) }
      # ensures the source points to a file which exists and is readable
      def loadable?
        ENV.key?(@source)
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the empty hash
      def load_source
        Dictionary.load(ENV.fetch(@source))
      end
    end
  end
end
