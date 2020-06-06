class RepresentSolution
  include Mandate

  initialize_with :exercise_slug, :path

  def call
    code = File.read(path / "#{exercise_slug.tr('-', '_')}.rb")
    representation = GenerateRepresentation.(code)

    File.open(path / "representation.txt","w") do |f|
      f.write(representation)
    end
  end
end

