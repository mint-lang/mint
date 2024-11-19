module Mint
  class Compiler
    def compile(node : Ast::CommentedExpression) : Compiled
      compile node do
        compile(node.expression)
      end
    end
  end
end
