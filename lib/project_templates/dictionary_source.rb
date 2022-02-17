# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  module DictionarySource
    extend T::Sig
    extend T::Helpers

    abstract!

    DESCRIPTION = T.let("Include this module and implement abstract methods to create a dictionary source.", String)

    sig { returns(T.nilable(Dictionary)) }
    # return the dictionary of the thing if it was loaded, otherwise nil
    attr_reader :dictionary

    sig { params(source: String).void }
    # store the source
    def initialize(source)
      @source = source
      @dictionary = T.let(nil, T.nilable(Dictionary))
    end

    sig { returns(String) }
    # the description of this data source
    def description
      DESCRIPTION
    end

    sig { returns(T::Boolean) }
    # true of dictionary is defined
    def loaded?
      !dictionary.eql?(nil)
    end

    sig { returns(T.nilable(Dictionary)) }
    # if loadable, try to create a dictionary from from the source
    def load
      @dictionary = load_source if loadable? && !loaded?
    rescue ArgumentError
      # There's nothing useful that can be done with the error so
      # just swallow it up and have a nil dictionary
      @dictionary = nil
    end

    sig { abstract.returns(T::Boolean) }
    # define this method to detect if the source can be loaded
    def loadable?; end

    sig { abstract.returns(T.nilable(Dictionary)) }
    # define this: assuming the source is not loaded but it is loadable
    def load_source; end
  end
end
