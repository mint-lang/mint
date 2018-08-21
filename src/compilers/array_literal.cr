module Mint
  class Compiler
    def _compile(node : Ast::ArrayLiteral) : String
      items =
        compile node.items, ", "

      "[#{items}]"
    end
  end
end
