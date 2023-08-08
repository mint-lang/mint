module Mint
  class Compiler
    def _compile(node : Ast::Variable) : String
      if node.value == "void"
        "null"
      else
        entity, parent = variables[node]

        # Subscriptions for providers are handled here
        if node.value == "subscriptions" && parent.is_a?(Ast::Provider)
          return "this._subscriptions"
        end

        # puts({entity.class, parent.class})

        case {entity, parent}
        when {Ast::Variable, Ast::Block},
             {Ast::Variable, Ast::Statement},
             {Ast::Variable, Ast::For},
             {Ast::Variable, Ast::CaseBranch},
             {Ast::Spread, Ast::CaseBranch}
          js.variable_of(entity)
        when {Ast::Component, Ast::Component},
             {Ast::HtmlElement, Ast::Component}
          case parent
          when Ast::Component
            ref =
              parent
                .refs
                .find { |(ref, _)| ref.value == node.value }
                .try { |(ref, _)| js.variable_of(ref) }

            "this.#{ref}"
          else
            raise "SHOULD NOT HAPPEN"
          end
        when {Ast::ConnectVariable, _}
          "this.#{js.variable_of(entity)}"
        else
          case entity
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
          when Ast::Property, Ast::Get, Ast::State, Ast::Constant
            name =
              js.variable_of(entity.as(Ast::Node))

            case parent
            when Ast::Suite
              # The variable is a constant in a test suite
              "constants.#{name}()"
            else
              "this.#{name}"
            end
          when Ast::Argument
            js.variable_of(entity)
          else
            "this.#{node.value}"
          end
        end
      end
    end
  end
end
