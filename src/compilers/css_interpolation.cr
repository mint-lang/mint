module Mint
  class Compiler
    def compile(node : Ast::CssInterpolation) : String
      compile node.expression
    end
  end
end
