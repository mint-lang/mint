module Mint
  class Compiler
    def _compile(node : Ast::CallExpression)
      compile node.expression
    end
  end
end
