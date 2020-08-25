require "test_helper"

class GenerateMappingTest < Minitest::Test
  def test_class
    code = %(
      class Foobar
      end
      BarFoo
    )
    mapping = { "Foobar" => "PLACEHOLDER_0" }
    assert_mapping(code, mapping)
  end

  def test_module
    code = %(
      module Foobar
      end
      BarFoo
    )
    mapping = { "Foobar" => "PLACEHOLDER_0" }
    assert_mapping(code, mapping)
  end

  def test_method
    code = %{
      def foobar
      end
      barfoo()
    }
    mapping = { "foobar" => "PLACEHOLDER_0" }
    assert_mapping(code, mapping)
  end

  def test_local_variables
    code = %(
      foobar = true
      puts barfoo
    )
    mapping = { "foobar" => "PLACEHOLDER_0" }
    assert_mapping(code, mapping)
  end

  def test_class_variables
    code = %(
      class Foobar
        foobar = true
      end
    )
    mapping = { "Foobar" => "PLACEHOLDER_0", "foobar" => "PLACEHOLDER_1" }
    assert_mapping(code, mapping)
  end

  def test_arguments
    code = %{
      def somefunc(foo, bar)
      end
      somefunc(a,b)
    }
    mapping = { "somefunc" => "PLACEHOLDER_0", "foo" => "PLACEHOLDER_1", "bar" => "PLACEHOLDER_2" }
    assert_mapping(code, mapping)
  end

  def test_attr_accessors
    code = %(
      class Foobar
        attr_reader :foobar
        attr_reader "other1", "other2"
        attr_writer :barfood
        attr_accessor :misc
      end
    )
    mapping = {
      "Foobar" => "PLACEHOLDER_0",
      "foobar" => "PLACEHOLDER_1",
      "other1" => "PLACEHOLDER_2",
      "other2" => "PLACEHOLDER_3",
      "barfood" => "PLACEHOLDER_4",
      "misc" => "PLACEHOLDER_5"
    }
    assert_mapping(code, mapping)
  end

  def assert_mapping(code, expected)
    actual = GenerateMapping.(code)
    assert_equal expected, actual
  end
end
