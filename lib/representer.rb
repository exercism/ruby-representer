require 'mandate'
require 'json'
require 'rubocop'
require 'parser/current'
require 'active_support/inflector'

require_relative 'generate_representation'

module Representer
  def self.generate(exercise_slug, path)
    pathname = Pathname.new(path)
    GenerateRepresentation.(exercise_slug, pathname)
  end
end
