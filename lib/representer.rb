EXERCISES = %w{
  two_fer
  acronym
}

FILENAMES = {
  "two-fer" => "two_fer.rb"
}

require 'mandate'
require 'json'
require 'rubocop'
require 'parser/current'
require 'active_support/inflector'

require_relative 'generate_representation'

module Representer
  def self.generate_representation(exercise_slug, path)
    pathname = Pathname.new(path)
    GenerateRepresentation.(exercise_slug, pathname)
  end
end
