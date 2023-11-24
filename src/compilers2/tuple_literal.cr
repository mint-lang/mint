module Mint
  class Compiler2
    def compile(node : Ast::TupleLiteral) : Compiled
      items =
        compile node.items

      js.array(items)
    end
  end
end
