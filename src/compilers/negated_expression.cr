module Mint
  class Compiler
    def _compile(node : Ast::NegatedExpression) : String
      expression =
        compile node.expression

      "#{node.negations}#{expression}"
    end
  end
end
