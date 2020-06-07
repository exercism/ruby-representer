class GenerateRepresentation
  include Mandate

  initialize_with :code

  def call
    Representation.new
    Extract
    # Normalise it
    normalizer = NamingNormalizer.new(code)
    normalizer.normalize!

    code = normalizer.normalized_code

    # Write it out
    buffer = Parser::Source::Buffer.new('', source: code)
    builder = RuboCop::AST::Builder.new
    ast = Parser::CurrentRuby.new(builder).parse(buffer)

    # Slim it down

    [ast, normalizer.mapping]
  end
end
