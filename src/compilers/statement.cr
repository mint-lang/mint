module Mint
  class Compiler
    def _compile(node : Ast::Statement) : String
      compile node.expression
    end
  end
end
