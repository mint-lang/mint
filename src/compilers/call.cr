module Mint
  class Compiler
    def _compile(node : Ast::Call) : Codegen::Node
      expression =
        compile node.expression

      arguments =
        Codegen.join(node.arguments, ", ") { |arg| Codegen.source_mapped(arg, compile arg) }

      if node.safe?
        js.iif do
          result =
            if node.partially_applied?
              if node.arguments.empty?
                "(_) => _"
              else
                Codegen.join ["((..._) => _(", arguments, ", ..._))"]
              end
            else
              Codegen.join ["(_) => _(", arguments, ")"]
            end

          js.statements([
            js.const("_", expression),
            js.return(js.call("_s", ["_", result])),
          ])
        end
      else
        case
        when node.partially_applied?
          if node.arguments.empty?
            expression
          else
            Codegen.join ["((..._) => ", expression, "(", arguments, ", ..._))"]
          end
        when node.expression.is_a?(Ast::InlineFunction)
          Codegen.join ["(", expression, ")(", arguments, ")"]
        else
          Codegen.join [expression, "(", arguments, ")"]
        end
      end
    end
  end
end
