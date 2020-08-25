class RepresentSolution
  include Mandate

  initialize_with :exercise_slug, :solution_path, :output_path

  def call
    code = File.read(solution_path / "#{exercise_slug.tr('-', '_')}.rb")
    representation = Representation.new(code)
    representation.normalize!

    File.open(output_path / "representation.txt","w") do |f|
      f.write(representation.ast)
    end

    File.open(output_path / "mapping.json","w") do |f|
      f.write(representation.mapping.to_json)
    end
  end
end

