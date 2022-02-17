# frozen_string_literal: true

require "test_helper"

class TestDictionaryLoader < Minitest::Test
  extend HasAttributeHelper
  include ClassUnderTest

  attr_accessor :loader, :sources

  test_has_attribute(:loader, :sources, readable: true)
  test_has_attribute(:loader, :dictionary, readable: true)
  test_has_attribute(:loader, :loadable_sources, readable: true)
  test_has_attribute(:loader, :loaded_source, readable: true)
  test_has_attribute(:loader, :loaded, readable: false, interrogatable: true)
  test_has_attribute(:loader, :loadable, readable: false, interrogatable: true)

  def setup
    @sources = [
      Minitest::Mock.new(ProjectTemplates::Sources::Empty.new),
      Minitest::Mock.new(ProjectTemplates::Sources::String.new({ foo: :bar }.to_json)),
      Minitest::Mock.new(ProjectTemplates::Sources::Empty.new),
    ]
    sources[0].expect(:loadable?, false)
    @loader = class_under_test.new(*sources)
  end

  def test_initalizes
    assert_nil(loader.dictionary)
    assert_nil(loader.loaded_source)
    assert_equal(sources, loader.sources)
    refute_predicate(loader, :loaded?)
  end

  def test_loadable_sources_checks_sources_for_loadability
    loader.loadable_sources
    sources.each(&:verify)
  end

  def test_loadable_sources_checks_for_all_loadable_sources
    assert_equal(sources[1..], loader.loadable_sources)
  end

  def test_loaded_source_is_loaded_source_that_succeedes
    possible_sources = [
      Minitest::Mock.new(ProjectTemplates::Sources::Empty.new),
      Minitest::Mock.new(ProjectTemplates::Sources::String.new({ foo: :bar }.to_json)),
      Minitest::Mock.new(ProjectTemplates::Sources::Empty.new),
    ]
    loader_test = class_under_test.new(*possible_sources)
    possible_sources[0].expect(:loadable?, false)
    possible_sources[1].expect(:loadable?, false)
    possible_sources[2].expect(:loadable?, true)
    loader_test.load
    assert_equal(possible_sources[2].object_id, loader_test.loaded_source.object_id)
  end

  def test_load_falls_through_loadable_sources_that_fail_to_load
    source1 = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source1.expect(:loadable?, true)
    source1.expect(:loaded?, false)
    source1.expect(:dictionary, nil)

    # can't be mocked because minitest doesn't do #==
    dictionary = ProjectTemplates::Dictionary.load({ foo: :bar }.to_json)
    source2 = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source2.expect(:loadable?, true)
    source2.expect(:loaded?, true)
    source2.expect(:dictionary, dictionary)

    loader_test = class_under_test.new(source1, source2)
    loader_test.load

    assert_predicate(loader_test, :loaded?)
    assert_equal(source2.object_id, loader_test.loaded_source.object_id)
    assert_equal(dictionary, loader_test.dictionary)
  end

  def test_loaded_source_is_nil_if_no_source_loads
    source = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source.expect(:loadable?, true)
    source.expect(:loaded?, false)
    source.expect(:dictionary, nil)
    loader_test = class_under_test.new(source)
    loader_test.load
    refute_predicate(loader_test, :loaded?)
    assert_nil(loader_test.loaded_source)
  end

  def test_loaded_is_false_if_load_doesnt_prodce_dictionary
    source = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source.expect(:loadable?, true)
    source.expect(:dictionary, nil)

    loader_test = class_under_test.new(source)
    loader_test.load

    refute_predicate(loader_test, :loaded?)
  end

  def test_loaded_is_true_if_load_produces_dictionary
    dictionary = Minitest::Mock.new(ProjectTemplates::Dictionary.load({ foo: :bar }.to_json))
    source = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source.expect(:loadable?, true)
    source.expect(:dictionary, dictionary)

    loader_test = class_under_test.new(source)
    loader_test.load

    assert_predicate(loader_test, :loaded?)
  end

  def test_dicionary_is_loaded_sources_dictionary
    # can't be mocked because minitest doesn't do #==
    dictionary = ProjectTemplates::Dictionary.load({ foo: :bar }.to_json)
    source = Minitest::Mock.new(ProjectTemplates::Sources::Empty.new)
    source.expect(:loadable?, true)
    source.expect(:dictionary, dictionary)

    loader_test = class_under_test.new(source)
    loader_test.load

    assert_equal(dictionary, loader_test.dictionary)
  end
end
