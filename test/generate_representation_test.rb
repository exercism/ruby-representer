require "test_helper"

class GenerateRepresentationTest < Minitest::Test

  def test_that_it_constantizes_correctly
    code = %q{
      class TwoFer
        def two_fer
          "foo"
        end
      end
    }
    representation = %q{(class (const nil :TwoFer) nil (def :two_fer (args) (str \"foo\")))}

    File.expects(:read).with(SAFE_WRITE_PATH / "two_fer.rb").returns(code)

    writer = mock
    writer.expects(:write).with(representation)
    File.expects(:open).
      with(SAFE_WRITE_PATH / "representation.txt", "w").yields(writer)
    GenerateRepresentation.('two-fer', SAFE_WRITE_PATH)
  end
end
