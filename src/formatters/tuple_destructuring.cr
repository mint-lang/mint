module Mint
  class Formatter
    def format(node : Ast::TupleDestructuring)
      "#(#{format(node.items, ", ")})"
    end
  end
end
