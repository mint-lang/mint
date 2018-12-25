module Mint
  class Compiler
    def _compile(node : Ast::ParenthesizedExpression) : String
      expression =
        compile node.expression

      "(#{expression})"
    end
  end
end
