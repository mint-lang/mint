module Mint
  class Compiler
    def _compile(node : Ast::ReturnCall) : String
      expression =
        compile node.expression

      js.return expression
    end
  end
end
