require 'mandate'
require 'json'
require 'rubocop'
require 'parser/current'
require 'active_support/inflector'

require_relative 'normalizers/naming_normalizer'

require_relative 'generate_mapping'

require_relative 'representation'
require_relative 'represent_solution'

require 'pry'

module Representer
  def self.generate(exercise_slug, solution_path, output_path)
    solution_pathname = Pathname.new(solution_path)
    output_pathname = Pathname.new(output_path)
    RepresentSolution.(exercise_slug, solution_pathname, output_pathname)
  end
end
