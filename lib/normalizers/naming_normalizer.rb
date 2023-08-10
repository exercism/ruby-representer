require 'parser/current'

# class Normalize < Parser::AST::Processor
class NamingNormalizer < Parser::TreeRewriter
  include Mandate

  def initialize(code, mapping)
    @original_code = code
    @mapping = mapping
    super()
  end

  def call
    buffer = Parser::Source::Buffer.new('', source: original_code)
    builder = RuboCop::AST::Builder.new
    ast = Parser::CurrentRuby.new(builder).parse(buffer)
    rewrite(buffer, ast)
  end

  %i[
    on_argument
    on_const
    on_def
    on_var
    on_vasgn
  ].each do |method_name|
    define_method method_name do |node|
      replace_loc_name(node)
      super(node)
    end
  end

  def on_send(node)
    # node.pry
    if !node.enumerator_method? &&
       !node.operator_method?
      replace_loc_selector(node)
    end

    super
  end

  # def process_regular_node
  #   super
  # end

  def on_op_asgn(node)
    p "opasgn"
    # node.pry
    super
  end

  def on_casgn(node)
    p "casgn"
    # node.pry
    super
  end

  def on_defs(node)
    p "defs"
    # node.pry
    super
  end

  def on_numblock(node)
    p "numblock"
    # node.pry
    super
  end

  def handler_missing(node)
    case node.type
    # noop
    when true, :str, :nil, :int
      super
    else
      p "handler_missing"
      # node.pry
    end
  end

  private
  attr_reader :original_code, :mapping

  def replace_loc_name(node)
    replace(node.loc.name, placeholder_for(node.loc.name.source))
  end

  def replace_loc_selector(node)
    replace(node.loc.selector, placeholder_for(node.loc.selector.source))
  end

  def placeholder_for(token)
    mapping.key?(token) ? mapping[token] : token
  end
end
