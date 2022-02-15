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
  class Dictionary < SimpleDelegator
    extend T::Sig
    # New is made private to ensure only a valid `OpenStruct` is passed to the class
    # constructor and delegation works as expected.
    private_class_method :new

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
        openstruct_input = JSON.parse(json_input, object_class: OpenStruct)

        raise(ArgumentError, "Input did not produce a dictionary") unless openstruct_input.is_a?(OpenStruct)

        new(openstruct_input)
      rescue JSON::JSONError, Psych::Exception => e
        raise(ArgumentError, e.to_s)
      end

      alias parse load
    end

    sig { returns(T::Hash[Symbol, T.untyped]) }
    # converts the dictionary into a ruby hash with symbolized keys. Values are
    # either int, float, bool, hash, array but to avoid a nightmare of sorbet
    # config I'm just going to say it's untyped
    def to_h
      t = ->(v) { v.is_a?(OpenStruct) ? v.table.transform_values { t[_1] } : v }
      t[@delegate_sd_obj]
    end
  end
end
