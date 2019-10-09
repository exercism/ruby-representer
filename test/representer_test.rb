require "test_helper"

class RepresenterTest < Minitest::Test
  def test_that_it_converts_to_path_and_runs
    slug = mock
    path = mock
    pathname = mock
    Pathname.expects(:new).with(path).returns(pathname)

    GenerateRepresentation.expects(:call).with(slug, pathname)
    Representer.generate_representation(slug, path)
  end
end
