require 'parser/current'

class GenerateMapping < Parser::AST::Processor
  include Mandate

  def initialize(code)
    @code = code
    @mapping = {}
  end

  def call
    buffer = Parser::Source::Buffer.new('', source: code)
    builder = RuboCop::AST::Builder.new
    ast = Parser::CurrentRuby.new(builder).parse(buffer)
    process(ast)
    mapping
  end

  %i[
    on_def
    on_vasgn
  ].each do |method_name|
    define_method method_name do |node|
      add_loc_name(node)
      super(node)
    end
  end

  #==============#
  # Not yet seen #
  #==============#

  def on_argument(node)
    add_entry(node.source)
  end

  def on_var(node)
    # p "on_var"
    # node.pry
    # super
  end

  # No-op
  # def on_send(node)
  #  #p "send"
  #  #node.pry
  #  super
  # end

  def process_regular_node
    p "regular_node"
    #node.pry
    super
  end

  def on_op_asgn(node)
    p "opasgn"
    #node.pry
    super
  end

  def on_casgn(node)
    p "casgn"
    #node.pry
    super
  end

  def on_defs(node)
    p "defs"
    #node.pry
    super
  end

  def on_numblock(node)
    p "numblock"
    #node.pry
    super
  end

  def process(node)
    return super unless node

    case node.type
    when :class, :module
      add_loc_name(node)
    else
      if node.respond_to?(:method_name)
        case node.method_name
        when :attr_reader, :attr_writer, :attr_accessor
          node.arguments.each do |arg|
            case arg.type
            when :sym
              add_entry(arg.loc.expression.source[1..-1])
            when :str
              add_entry(arg.value)
            end
            # add_entry(arg)
          end
          # else
          # p "process"
          # node.pry
        end
      end
    end

    super
  end

  def handler_missing(node)
    case node.type
    # noop
    when true, :str, :nil, :int, :sym
      super
    else
      p "handler_missing"
      #node.pry
    end
  end

  private
  attr_reader :code, :mapping

  def add_loc_name(node)
    add_entry(node.loc.name.source)
  end

  def add_entry(token)
    return if mapping.key?(token)

    # The placeholder case should match the token case
    if token[0] == token[0].capitalize
      mapping[token] = "PLACEHOLDER_#{mapping.size}"
    else
      mapping[token] = "placeholder_#{mapping.size}"
    end
  end
end
