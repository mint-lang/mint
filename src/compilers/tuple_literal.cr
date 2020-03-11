module Mint
  class Compiler
    def _compile(node : Ast::TupleLiteral) : String
      items =
        compile node.items, ", "

      "[#{items}]"
    end
  end
end
