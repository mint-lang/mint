module Mint
  class Compiler
    def compile(node : Ast::Test) : Compiled
      compile node do
        location =
          [Raw.new(node.location.to_json)]

        name =
          compile node.name

        expression =
          case operation = node.expression
          when Ast::Operation
            if (operator = operation.operator).in?("==", "!=")
              right =
                compile operation.right

              left =
                compile operation.left

              js.call(
                Builtin::TestOperation,
                [left, right, [operator] of (Item)])
            end
          end || compile(node.expression)

        js.object({
          "proc"     => js.arrow_function { js.return(expression) },
          "location" => location,
          "name"     => name,
        })
      end
    end
  end
end
