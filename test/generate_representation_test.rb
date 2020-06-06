require "test_helper"

class GenerateRepresentationTest < Minitest::Test
  def test_basic_representation
    code = %q{
      class TwoFer
        def two_fer
          "foo"
        end
      end
    }
    representation = %q{(class (const nil :PLACEHOLDER_0) nil (def :PLACEHOLDER_1 (args) (str \"foo\")))}
    assert_equal representation, GenerateRepresentation.(code)[0]
  end
end
