class RepresentSolution
  include Mandate

  initialize_with :exercise_slug, :path

  def call
    code = File.read(path / "#{exercise_slug.tr('-', '_')}.rb")
    representation = Representation.new(code)
    representation.normalize!

    File.open(path / "representation.txt","w") do |f|
      f.write(representation.ast)
    end

    File.open(path / "mapping.json","w") do |f|
      f.write(representation.mapping.to_json)
    end
  end
end

