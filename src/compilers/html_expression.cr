module Mint
  class Compiler
    def _compile(node : Ast::HtmlExpression) : String
      compile node.expression
    end
  end
end
