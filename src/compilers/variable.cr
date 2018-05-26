module Mint
  class Compiler
    def compile(node : Ast::Variable) : String
      item = variables[node]

      # State is handled here
      if node.value == "state" &&
         item[0].is_a?(TypeChecker::Record | Ast::Record | Ast::RecordUpdate | Ast::State) &&
         item[1].is_a?(Ast::Component | Ast::Store)
        return "this.state"
      end

      # Subscriptions for providers are handled here
      if node.value == "subscriptions" && item[1].is_a?(Ast::Provider)
        return "this._subscriptions"
      end

      case item[0]
      when Ast::Function
        entity = item[1]
        case entity
        when Ast::Module, Ast::Store
          if item[2].size == 1 && entity.functions.includes?(item[0])
            "this.#{node.value}.bind(this)"
          else
            "$#{underscorize(entity.name)}.#{node.value}"
          end
        else
          "this.#{node.value}.bind(this)"
        end
      when Ast::Property, Ast::Get
        "this.#{node.value}"
      else
        node.value
      end
    end
  end
end
