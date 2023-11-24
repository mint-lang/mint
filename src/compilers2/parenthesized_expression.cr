module Mint
  class Compiler2
    def compile(node : Ast::ParenthesizedExpression) : Compiled
      expression =
        compile node.expression

      ["("] + expression + [")"]
    end
  end
end
