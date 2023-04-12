module NamingNormalizers
  class Base < Parser::TreeRewriter
    include Mandate

    def initialize(code)
      @code = code
      @mapping = {}
    end

    def call
      buffer = Parser::Source::Buffer.new('', source: code)
      builder = RuboCop::AST::Builder.new
      ast = Parser::CurrentRuby.new(builder).parse(buffer)
      rewrite(buffer, ast)
    end

    def on_op_asgn(node)
      # p "opasgn"
      #node.pry
      super
    end

    def on_casgn(node)
      # p "casgn"
      #node.pry
      super
    end

    def on_defs(node)
      # p "defs"
      #node.pry
      super
    end

    def on_numblock(node)
      # p "numblock"
      #node.pry
      super
    end

    def handler_missing(node)
      case node.type
      # noop
      when true, :str, :nil, :int
        super
      else
        p "handler_missing"
        #node.pry
      end
    end

    private
    attr_reader :code, :mapping
  end
end
