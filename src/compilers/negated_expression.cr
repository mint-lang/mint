module Mint
  class Compiler
    def _compile(node : Ast::NegatedExpression) : Codegen::Node
      expression =
        compile node.expression

      Codegen.join [node.negations, expression]
    end
  end
end
