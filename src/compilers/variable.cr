module Mint
  class Compiler
    def _compile(node : Ast::Variable) : String
      item = variables[node]

      # Subscriptions for providers are handled here
      if node.value == "subscriptions" && item[1].is_a?(Ast::Provider)
        return "this._subscriptions"
      end

      case item[0]
      when Ast::Function
        entity = item[1]
        case entity
        when Ast::Module, Ast::Store
          name =
            underscorize(entity.name)

          "$#{name}.#{node.value}.bind($#{name})"
        else
          "this.#{node.value}.bind(this)"
        end
      when Ast::Property, Ast::Get, Ast::State
        "this.#{node.value}"
      else
        node.value
      end
    end
  end
end
