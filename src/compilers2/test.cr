module Mint
  class Compiler2
    def compile(node : Ast::Test) : Compiled
      name =
        compile node.name

      location =
        [Raw.new(node.location.to_json)]

      expression =
        case operation = node.expression
        when Ast::Operation
          if (operator = operation.operator).in?("==", "!=")
            right =
              compile operation.right

            left =
              compile operation.left

            js.call(Builtin::TestOperation, [left, right, [operator] of (Item)])
          end
        end || compile(node.expression)

      js.object({
        "proc"     => js.async_arrow_function { js.return(expression) },
        "location" => location,
        "name"     => name,
      })
    end
  end
end
