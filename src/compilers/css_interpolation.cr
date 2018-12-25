module Mint
  class Compiler
    def _compile(node : Ast::CssInterpolation) : String
      compile node.expression
    end
  end
end
