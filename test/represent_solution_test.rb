require "test_helper"

class RepresentateSolutionTest < Minitest::Test
  def test_extracts_and_writes_code_correctly
    code = "some code"
    ast = "some representation"
    code_filepath = "foooooo.rb"
    mapping = { foo: 'bar' }
    representation = mock
    representation.stubs(ast:)
    representation.stubs(mapping:)
    representation.expects(:normalize!)

    config = { files: { solution: [code_filepath] } }.to_json

    Representation.expects(:new).with(code).returns(representation)
    File.expects(:read).with(SOLUTION_PATH / ".meta/config.json").returns(config)

    File.expects(:read).with(SOLUTION_PATH / code_filepath).returns(code)
    writer = mock
    writer.expects(:write).with(ast)
    File.expects(:open).
      with(SAFE_WRITE_PATH / "representation.txt", "w").yields(writer)

    writer_2 = mock
    writer_2.expects(:write).with(mapping.to_json)
    File.expects(:open).
      with(SAFE_WRITE_PATH / "mapping.json", "w").yields(writer_2)

    RepresentSolution.("two-fer", SOLUTION_PATH, SAFE_WRITE_PATH)
  end
end
