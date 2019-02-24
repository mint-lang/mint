module Mint
  class Compiler
    def _compile(node : Ast::Variable) : String
      entity, parent = variables[node]

      # Subscriptions for providers are handled here
      if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
        return "this._subscriptions"
      end

      case parent
      when Tuple(String, TypeChecker::Checkable, Ast::Node)
        js.variable_of(parent[2])
      else
        case entity
        when Ast::Component, Ast::HtmlElement
          "this._#{node.value}"
        when Ast::Function
          function =
            js.variable_of(entity.as(Ast::Node))

          case parent
          when Ast::Module, Ast::Store
            name =
              js.class_of(parent.as(Ast::Node))

            "#{name}.#{function}"
          else
            "this.#{function}"
          end
        when Ast::Property, Ast::Get, Ast::State
          name =
            js.variable_of(entity.as(Ast::Node))

          "this.#{name}"
        when Ast::Argument
          compile entity
        when Ast::WhereStatement, Ast::Statement
          js.variable_of(entity.as(Ast::Node))
        else
          "this.#{node.value}"
        end
      end
    end
  end
end
