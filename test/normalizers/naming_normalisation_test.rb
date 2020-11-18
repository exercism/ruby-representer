require "test_helper"

class NamingNormalisationTest < Minitest::Test
  def test_variable_name
    code = "foobar = true"
    representation = "placeholder_0 = true"
    assert_representation code, representation
  end

  def test_class_name
    code = "class Foobar; end"
    representation = "class PLACEHOLDER_0; end"
    assert_representation code, representation
  end

  def test_method_name
    code = "def foobar; end"
    representation = "def placeholder_0; end"
    assert_representation code, representation
  end

  def test_if
    code = "foo = true; if foo then 'bar' else nil end"
    representation = "placeholder_0 = true; if placeholder_0 then 'bar' else nil end"
    assert_representation code, representation
  end

  def test_return
    code = "foo = true; return foo"
    representation = "placeholder_0 = true; return placeholder_0"
    assert_representation code, representation
  end

  def test_method_call
    code = '
      def bar; end
      foo.bar
    '
    representation = '
      def placeholder_0; end
      foo.placeholder_0
    '
    assert_representation code, representation
  end

  def test_non_defined_method_call
    code = "foo = []; foo.each"
    representation = "placeholder_0 = []; placeholder_0.each"
    assert_representation code, representation
  end

  def test_args
    code = %{
      foo = 1
      bar = 2
      def somefunc(param1, bar)
        return param1 + bar
      end
    }
    representation = %{
      placeholder_0 = 1
      placeholder_1 = 2
      def placeholder_2(placeholder_3, placeholder_1)
        return placeholder_3 + placeholder_1
      end
    }
    assert_representation code, representation
  end

  def test_complex_example
    code = '
      class TwoFer
        def two_fer
          "foo"
        end

        def foobar
          two_fer = "cat"
          return TwoFer.two_fer
        end
      end
    '
    representation = '
      class PLACEHOLDER_0
        def placeholder_1
          "foo"
        end

        def placeholder_2
          placeholder_1 = "cat"
          return PLACEHOLDER_0.placeholder_1
        end
      end
    '
    assert_representation(code, representation)
  end

  def assert_representation(code, expected)
    mapping = GenerateMapping.(code)
    actual = NamingNormalizer.(code, mapping)
    assert_equal expected.strip, actual.strip
  end
end
