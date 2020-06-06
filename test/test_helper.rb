gem 'minitest'

require "minitest/autorun"
require 'minitest/pride'
require "mocha/minitest"

class Minitest::Test
  SAFE_WRITE_PATH = Pathname.new('/tmp')
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "representer"

class Minitest::Test

end
