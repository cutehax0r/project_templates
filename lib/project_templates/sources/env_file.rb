# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    class EnvFile
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a file containing YAML or JSON pointed at by an environment variable."

      sig { override.params(source: ::String).void }
      # pass the path of a file in an environment variable named in source
      def initialize(source)
        @source = source
        target_path = Pathname.new(ENV.fetch("source", nil)).expand_path
        @path = T.let(target_path, Pathname) if target_path
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
