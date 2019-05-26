module Mint
  class Compiler
    def _compile(node : Ast::Call) : String
      expression =
        compile node.expression

      arguments =
        compile node.arguments, ", "

      if node.safe
        js.iif do
          result =
            if node.partially_applied
              if node.arguments.empty?
                "(_) => _"
              else
                "((..._) => _(#{arguments}, ..._))"
              end
            else
              "(_) => _(#{arguments})"
            end

          js.statements([
            js.const("_", expression),
            js.return(js.call("_s", ["_", result])),
          ])
        end
      else
        if node.partially_applied
          if node.arguments.empty?
            expression
          else
            "((..._) => #{expression}(#{arguments}, ..._))"
          end
        else
          "#{expression}(#{arguments})"
        end
      end
    end
  end
end
