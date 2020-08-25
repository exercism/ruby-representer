class Representation
  attr_reader :mapping

  def initialize(source_code)
    @source_code = source_code
    @processed_code = source_code
  end

  def normalize!
    self.mapping = GenerateMapping.(source_code)
    self.processed_code = NamingNormalizer.(processed_code, mapping)
  end

  def ast
    buffer = Parser::Source::Buffer.new('', source: processed_code)
    builder = RuboCop::AST::Builder.new
    ast = Parser::CurrentRuby.new(builder).parse(buffer)

    # Slim it down
    ast.to_s.tr("\n", " ").squeeze(" ").gsub('"', '\"')
  end

  private
  attr_reader :source_code
  attr_accessor :processed_code
  attr_writer :mapping
end
