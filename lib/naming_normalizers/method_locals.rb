module NamingNormalizers
  class MethodLocals < Base

    def initialize(code)
      super(code)

      @method_name = nil
      @methods_vars = {}
    end

    %i[
      on_argument
      on_const
      on_var
      on_vasgn
    ].each do |method_name|
      define_method method_name do |node|
        replace_loc_name(node)
        super(node)
      end
    end

    def on_def(node)
      @method_name = node.loc.name.source
      @methods_vars[@method_name] = {}

      super(node)
    end

    def on_end(node)
      node.pry
    end

    def handler_missing(node)
      super(node)
    end

    def replace_loc_name(node)
      replace(node.loc.name, placeholder_for(node.loc.name.source))
    end

    def replace_loc_selector(node)
      replace(node.loc.selector, placeholder_for(node.loc.selector.source))
    end

    def placeholder_for(token)
      # Return if we're outside of a method
      return token unless instance_variable_defined?("@method_name") && @method_name

      # Get the vars for this method_naem
      meth_vars = @methods_vars[@method_name]

      # Return if we have one
      return meth_vars[token] if meth_vars.key?(token)
        
      # Else get out of here
      meth_vars[token] = "#{@method_name}_#{meth_vars.length}"
    end
  end
end
