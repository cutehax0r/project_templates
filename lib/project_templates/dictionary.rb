# frozen_string_literal: true
# typed: strict

require "delegate"
require "json"
require "yaml"
require "sorbet-runtime"

module ProjectTemplates
  # Dictionary wraps a set of nested key-value pairs loaded form some source.
  # The keys loaded form the source will be methods on the dictionary which will
  # return their values. In the case of nested key/value pairs, all of the values
  # are recursively turned into methods.
  #
  # in the event you really want an ordinary Hash instead of an openstruct you
  # can always call `.table` on a key to get it's value as a hash with
  # symbolized keys.
  class Dictionary
    extend T::Sig

    PARSE_OPTS = T.let(
      {
        max_nesting: 5,
        allow_nan: false,
        symbolize_names: true,
        object_class: Hash,
      },
      T::Hash[Symbol, T.any(Integer, T::Boolean, Object)]
    )

    class << self
      extend T::Sig

      sig { params(input: String).returns(T.attached_class) }
      # You can pass a string and so long as it passes through the YAML and JSON
      # parser to produce an `OpenStruct` then everything is fine. Some valid JSON
      # and YAML will not produce a dictionary. E.g. "[1, 2, 3]" is valid for
      # both JSON and YAML but parses to an `Array`. Invalid JSON will also cause
      # an error. If a valid `OpenStruct` cannot be formed `ArgumentError` is raised.
      def load(input)
        yaml_input = YAML.safe_load(input)
        json_input = yaml_input.to_json
        new(json_input)
      rescue Psych::Exception => e
        raise(ArgumentError, e.to_s)
      end
    end

    sig { params(source: String).void }
    # expects source to be JSON, instantiates the dictionary using it.
    def initialize(source)
      @hash = T.let(JSON.parse(source, PARSE_OPTS), T::Hash[Symbol, T.untyped])
      @struct = T.let(JSON.parse(source, PARSE_OPTS.merge(object_class: OpenStruct)), OpenStruct)
    rescue JSON::JSONError, Psych::Exception, TypeError => e
      raise(ArgumentError, e.to_s)
    end

    sig { params(method: T.any(String, Symbol), _include_private: T.untyped).returns(T.untyped) }
    # As methods are delegated to the backing openstruct, this will ensure that
    # behaviour for things like "respond_to?" and "method()" work as expected
    def respond_to_missing?(method, _include_private = false)
      @struct.respond_to?(method) || super
    end

    sig { params(method: T.any(String, Symbol), _args: T.untyped, _block: T.untyped).returns(T.untyped) }
    # methods on the dictionary are passed to the openstruct containing all of
    # the data. Accessing a key that is not defined raises the expected NoMethodError
    # rather than silently returning nil.
    def method_missing(method, *_args, &_block)
      @struct.respond_to?(method) ? @struct.send(method) : super
    end

    sig { returns(T::Hash[Symbol, T.untyped]) }
    # Returns the dictionary as a ruby hash. Useful for merging dictionaries or
    # iterating over key-value pairs
    def to_h
      @hash
    end
  end
end
