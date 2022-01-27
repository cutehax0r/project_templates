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
    # New is made private to ensure only a valid `OpenStruct` is passed to the class
    # constructor and delegation works as expected.
    private_class_method :new

    class << self
      extend T::Sig

      sig { params(input: T.any(String, OpenStruct, T::Hash[T.untyped, T.untyped])).returns(Dictionary) }
      # The valid inputs to load variables are:
      #   * `Hash`: a standard ruby dictionary of nested key_value pairs. All keys
      #      must respond to `to_sym` or loading will fail.
      #   * `OpenStruct` containing nested key/value pairs.
      #   * `String` containing YAML,
      #   * `String` containing JSON.
      # All inputs will be recursively parsed into `OpenStructs`. Any keys in the
      # input will then become methods on the `Dictionary`.
      def load(input)
        case input
        when OpenStruct then load_string(JSON.dump(input.table))
        when Hash then new(OpenStruct.new(input))
        when String then load_string(input)
        else T.absurd(input)
        end
      end

      alias parse load

      private

      sig { params(input: String).returns(Dictionary) }
      # You can pass a string and so long as it passes through the YAML and JSON
      # parser to produce an `OpenStruct` then everything is fine. Some valid JSON
      # and YAML will not produce a dictionary. E.g. "[1, 2, 3]" is valid for
      # both JSON and YAML but parses to an `Array`. Invalid JSON will also cause
      # an error. If a valid `OpenStruct` cannot be formed `ArgumentError` is raised.
      def load_string(input)
        yaml_input = YAML.safe_load(input)
        json_input = yaml_input.to_json
        openstruct_input = JSON.parse(json_input, object_class: OpenStruct)

        raise(ArgumentError, "Input did not produce a dictionary") unless openstruct_input.is_a?(OpenStruct)

        new(openstruct_input)
      rescue JSON::JSONError, Psych::Exception => e
        raise(ArgumentError, e.to_s)
      end
    end
  end
end
