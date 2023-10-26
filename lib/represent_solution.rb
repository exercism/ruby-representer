require 'json'

class RepresentSolution
  include Mandate

  initialize_with :exercise_slug, :solution_path, :output_path

  def call
    representation = Representation.new(code)
    representation.normalize!

    File.open(output_path / "representation.txt", "w") do |f|
      f.write(representation.ast)
    end

    File.open(output_path / "mapping.json", "w") do |f|
      f.write(representation.mapping.to_json)
    end
  end

  memoize
  def code
    filenames.map { |filename| File.read(solution_path / filename) }.join(" ")
  end

  memoize
  def filenames
    config = JSON.parse(File.read(solution_path / '.meta' / 'config.json'))
    config['files']['solution']
  end
end
