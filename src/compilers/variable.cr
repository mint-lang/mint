module Mint
  class Compiler
    def _compile(node : Ast::Variable) : String
      entity, parent = variables[node]

      # Subscriptions for providers are handled here
      if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
        return "this._subscriptions"
      end

      case entity
      when Ast::Function
        case parent
        when Ast::Module, Ast::Store
          name =
            underscorize(parent.name)

          "$#{name}.#{node.value}.bind($#{name})"
        else
          "this.#{node.value}.bind(this)"
        end
      when Ast::Property, Ast::Get, Ast::State
        "this.#{node.value}"
      when Ast::Argument
        compile entity
      else
        node.value
      end
    end
  end
end
