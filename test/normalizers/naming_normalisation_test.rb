require "test_helper"

class NamingNormalisationTest < Minitest::Test
  def test_variable_name
    code = "foobar = true"
    representation = "PLACEHOLDER_0 = true"
    assert_representation code, representation
  end

  def test_class_name
    code = "class Foobar; end"
    representation = "class PLACEHOLDER_0; end"
    assert_representation code, representation
  end

  def test_method_name
    code = "def foobar; end"
    representation = "def PLACEHOLDER_0; end"
    assert_representation code, representation
  end

  def test_if
    code = "foo = true; if foo then 'bar' else nil end"
    representation = "PLACEHOLDER_0 = true; if PLACEHOLDER_0 then 'bar' else nil end"
    assert_representation code, representation
  end

  def test_return
    code = "foo = true; return foo"
    representation = "PLACEHOLDER_0 = true; return PLACEHOLDER_0"
    assert_representation code, representation
  end

  def test_method_call
    code = %q{
      def bar; end
      foo.bar
    }
    representation = %q{
      def PLACEHOLDER_0; end
      foo.PLACEHOLDER_0
    }
    assert_representation code, representation
  end
  
  def test_non_defined_method_call
    code = "foo = []; foo.each"
    representation = "PLACEHOLDER_0 = []; PLACEHOLDER_0.each"
    assert_representation code, representation
  end


  def test_args
    code = %Q{
      foo = 1
      bar = 2
      def somefunc(param1, bar)
        return param1 + bar
      end
    }
    representation = %Q{
      PLACEHOLDER_0 = 1
      PLACEHOLDER_1 = 2
      def PLACEHOLDER_2(PLACEHOLDER_3, PLACEHOLDER_1)
        return PLACEHOLDER_3 + PLACEHOLDER_1
      end
    }
    assert_representation code, representation
  end

  def test_complex_example
    code = %q{
      class TwoFer
        def two_fer
          "foo"
        end

        def foobar
          two_fer = "cat"
          return TwoFer.two_fer
        end
      end
    }
    representation = %q{
      class PLACEHOLDER_0
        def PLACEHOLDER_1
          "foo"
        end

        def PLACEHOLDER_2
          PLACEHOLDER_1 = "cat"
          return PLACEHOLDER_0.PLACEHOLDER_1
        end
      end
    }
    assert_representation(code, representation)
  end

  def assert_representation(code, expected)
    mapping = GenerateMapping.(code)
    actual = NamingNormalizer.(code, mapping)
    assert_equal expected.strip, actual.strip
  end
end

