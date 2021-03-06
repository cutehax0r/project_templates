# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module Sources
    # Always returns an empty dictionary. Because no external data is needed
    # you can be sure this always works. Use this as the lowest priority
    # source in a dictionary loader to ensure you always get back an
    # empty dictionary rather than 'nil'.
    class Empty
      extend T::Sig
      include DictionarySource

      DESCRIPTION = "Returns an empty dictionary."

      sig { void }
      # no input needed, the source is always an empty dictionary
      def initialize
        @source = {}.to_json
      end

      sig { override.returns(T::Boolean) }
      # empty sources are always loadable.
      def loadable?
        true
      end

      sig { override.returns(T.nilable(Dictionary)) }
      # Creates a new dictionary from the empty hash
      def load_source
        Dictionary.load(@source)
      end
    end
  end
end
