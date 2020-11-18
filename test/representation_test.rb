require "test_helper"

class RepresentationTest < Minitest::Test
  def test_basic_representation
    code = '
      class TwoFer
        def two_fer
          "foo"
        end
      end
    '
    representation = Representation.new(code)
    representation.normalize!

    mapping = {
      "TwoFer" => "PLACEHOLDER_0",
      "two_fer" => "placeholder_1"
    }
    assert_equal mapping, representation.mapping

    ast = %q{(class  (const nil :PLACEHOLDER_0) nil  (def :placeholder_1    (args)    (str "foo")))}
    assert_equal ast, representation.ast
  end
end
