class GenerateRepresentation
  include Mandate

  initialize_with :code

  def call
    # Normalise it
    normalizer = Normalizer.new(code)
    normalizer.normalize!

    code = normalizer.normalized_code

    # Write it out
    buffer = Parser::Source::Buffer.new('', source: code)
    builder = RuboCop::AST::Builder.new
    ast = Parser::CurrentRuby.new(builder).parse(buffer)

    # Slim it down
    ast =  ast.to_s.gsub("\n", " ").squeeze(" ").gsub('"', '\"'),

    [ast, normalizer.mapping]
  end
end
