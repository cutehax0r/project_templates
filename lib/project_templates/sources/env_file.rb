# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    class EnvFile
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a file containing YAML or JSON pointed at by an environment variable."

      def intiialize(source)
        @source = source
        target_file = ENV.fetch("source", nil)
        @path = Pathname.new(target_file).expand_path if target_file
      end

      sig { override.returns(T::Boolean) }
      # ensures the source points to a file which exists and is readable
      def loadable?
        @path.readable?
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the empty hash
      def load_source
        Dictionary.load(@path.read)
      end
    end
  end
end
