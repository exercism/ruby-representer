class GenerateRepresentation
  include Mandate

  initialize_with :exercise_slug, :path

  def call
    code_to_analyze = File.read(path / "#{exercise_slug.tr('-', '_')}.rb")

    buffer        = Parser::Source::Buffer.new(nil)
    buffer.source = code_to_analyze
    builder       = RuboCop::AST::Builder.new
    parser        = Parser::CurrentRuby.new(builder)
    ast           =  parser.parse(buffer)

    File.open(path / "representation.txt","w") do |f|
      f.write(ast.to_s)
    end
  end
end
