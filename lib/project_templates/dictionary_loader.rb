# frozen_string_literal: true
# typed: strict

require "sorbet-runtime"

module ProjectTemplates
  # Dictionary loader is a way to load a dictionary from multiple possible
  # locations. It models the idea that there are multiple possible sources
  # and you should look at each one in priority order and use the first match.
  # A dictionary Loader returns a Dictionary from from one of several possible
  # sources or it returns nil. You will probably want one dictionary loader for
  # each "configuration source" that your application has.
  #
  # Maybe this should be abstract and you force people to create loaders for
  # specific dictionaries?
  # Maybe that should be a factory pattern?
  class DictionaryLoader
    extend T::Sig

    sig { returns(T.nilable(Dictionary)) }
    # the loaded dictionary from the highest priority source that could be loaded
    attr_reader :dictionary

    sig { returns(T::Array[DictionarySource]) }
    # The sources that are candidates to be loaded form
    attr_reader :sources

    sig { returns(T.nilable(DictionarySource)) }
    # If a source is loaded, then this is a reference back to which one it was
    attr_reader :loaded_source

    sig { params(sources: DictionarySource).void }
    # sources is a list of dictionary source objects. Pass them in prioritized
    # where lower index is higher priority.
    def initialize(*sources)
      @sources = T.let(sources.to_a, T::Array[DictionarySource])
      @loadable_sources = T.let(nil, T.nilable(T::Array[DictionarySource]))
      @loaded_source = T.let(nil, T.nilable(DictionarySource))
      @dictionary = T.let(nil, T.nilable(Dictionary))
    end

    sig { void }
    # Attempt to load a dictionary from the sources
    def load
      return if loaded? || !loadable?

      @loaded_source = loadable_sources.find do |source|
        source.load
        source.loaded?
      end
      @dictionary = loaded_source&.dictionary
    end

    sig { returns(T::Boolean) }
    # if loading was attempted, was it successful?
    def loaded?
      !dictionary.eql?(nil)
    end

    sig { returns(T::Boolean) }
    # are there any dictionary sources that are actually loadable
    def loadable?
      loadable_sources.any?
    end

    sig { returns(T::Array[DictionarySource]) }
    # This list of possibly loaded sources
    def loadable_sources
      @loadable_sources ||= sources.select(&:loadable?)
    end
  end
end
