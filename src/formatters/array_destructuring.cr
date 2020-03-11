module Mint
  class Formatter
    def format(node : Ast::ArrayDestructuring)
      "[#{format(node.items, ", ")}]"
    end
  end
end
