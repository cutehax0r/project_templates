# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    class File
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns a dictionary from a string pointing to a file containing YAML or JSON."

      def initialize(source)
        @source = source
        @path = Pathname.new(@source).expand_path
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
