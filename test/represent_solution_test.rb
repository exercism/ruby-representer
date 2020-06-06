require "test_helper"

class RepresentateSolutionTest < Minitest::Test
  def test_extracts_and_writes_code_correctly
    code = "some code"
    representation = "some representation"

    GenerateRepresentation.expects(:call).with(code).returns(representation)
    File.expects(:read).with(SAFE_WRITE_PATH / "two_fer.rb").returns(code)
    writer = mock
    writer.expects(:write).with(representation)
    File.expects(:open).
      with(SAFE_WRITE_PATH / "representation.txt", "w").yields(writer)
    RepresentSolution.("two-fer", SAFE_WRITE_PATH)
  end
end

