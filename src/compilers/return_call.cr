module Mint
  class Compiler
    def _compile(node : Ast::ReturnCall) : String
      expression =
        compile node.expression

      js.throw expression
    end
  end
end
