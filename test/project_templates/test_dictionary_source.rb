# frozen_string_literal: true

require "test_helper"

class TestDictionarySource < MiniTest::Test
  include ClassUnderTest

  attr_reader :klass, :source

  def setup
    @klass = Class.new.include(class_under_test)
    @source = klass.new("{}")
  end

  def test_has_description_constant
    assert_equal(
      "Include this module and implement abstract methods to create a dictionary source.",
      class_under_test::DESCRIPTION
    )
  end

  def test_loaded_is_false_by_default
    refute_predicate(source, :loaded?)
  end

  def test_loaded_is_true_if_load_passes
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:load_source) { Minitest::Mock.new(ProjectTemplates::Dictionary.load("{}")) }
    source.load
    assert_predicate(source, :loaded?)
  end

  def test_loaded_is_false_if_load_failes
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:load_source) { nil }
    source.load
    refute_predicate(source, :loaded?)
  end

  def test_has_description
    assert_respond_to(source, :description)
  end

  def test_description_returns_constant_description
    assert_equal(class_under_test::DESCRIPTION, source.description)
  end

  def test_has_dictionary
    assert_respond_to(source, :dictionary)
  end

  def test_dictionary_is_nil_by_default
    assert_nil(source.dictionary)
  end

  def test_dictionary_is_a_dictionary_after_loading
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:load_source) { Minitest::Mock.new(ProjectTemplates::Dictionary.load("{}")) }
    source.load
    assert_instance_of(ProjectTemplates::Dictionary, source.dictionary)
  end

  def test_loadable_is_abstract
    assert_raises(NotImplementedError) { source.loadable? }
  end

  def test_loadable_checked_by_load
    loadable = Minitest::Mock.new.expect(:check!, true)
    source.define_singleton_method(:loadable?) { loadable.check! }
    source.define_singleton_method(:load_source) { nil }
    source.load
    loadable.verify
  end

  def test_load_source_is_abstract
    assert_raises(NotImplementedError) { source.send(:load_source) }
  end

  def test_load_source_called_if_loadable
    loader = Minitest::Mock.new.expect(:load!, true)
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:load_source) { loader.load! }
    source.load
    loader.verify
  end

  def test_load_source_not_called_if_not_loadable
    source.define_singleton_method(:loadable?) { false }
    source.define_singleton_method(:load_source) do
      raise(MethodError, "unloadable source should not call load_source")
    end
    assert(source.load)
  end

  def test_load_source_not_called_if_loaded
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:loaded?) { true }
    source.define_singleton_method(:load_source) do
      raise(MethodError, "loaded source should not call load_source")
    end
    source.load
  end

  def test_load_consumes_argument_errors_from_load_source
    source.define_singleton_method(:loadable?) { true }
    source.define_singleton_method(:load_source) { raise(ArgumentError, "simulate source load failure") }
    source.load
  end
end
