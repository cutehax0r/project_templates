# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    # Wraps a file that can be loaded as YAML or JSON. This works similar to
    # the `File` source except that instead of source pointing at a file, it
    # points at an environment variable that points to a file. It's a way of
    # allowing default config or per-instance changes that don't depend
    # necessarily on a specific file path. It's a way of introducing a layer
    # of indirection into config but otherwise behaves like the File source.
    # Gracefully handles missing environment variables.
    class EnvFile
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a file containing YAML or JSON pointed at by an environment variable."

      sig { params(source: ::String).void }
      # pass the path of a file in an environment variable named in source
      def initialize(source)
        @source = source
        @dictionary = T.let(nil, T.nilable(Dictionary))
        @path = T.let(nil, T.nilable(Pathname))
        env_path = ENV.fetch(source.upcase, false)
        @path = Pathname.new(env_path).expand_path if env_path
      end

      sig { override.returns(T::Boolean) }
      # ensures the source points to a file which exists and is readable
      def loadable?
        !!@path&.readable?
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the empty hash
      def load_source
        Dictionary.load(T.must(@path).read)
      end
    end
  end
end
