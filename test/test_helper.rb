# This must happen above the env require below
if ENV["CAPTURE_CODE_COVERAGE"]
  require 'simplecov'
  SimpleCov.start
end

gem 'minitest'

require "minitest/autorun"
require 'minitest/pride'
require "mocha/minitest"
require 'pathname'

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp/output')
  SOLUTION_PATH = Pathname.new('/tmp')

  def assert_representation(code, representation)
    assert_equal representation.strip, GenerateRepresentation.(code).first
  end
end

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "representer"

class Minitest::Test
end
