module Mint
  class Compiler2
    def compile(node : Ast::ReturnCall) : Compiled
      expression =
        compile node.expression

      js.return expression
    end
  end
end
