module Mint
  class Formatter
    def format(node : Ast::Access) : Nodes
      format(node.expression) + [".", node.field.value]
    end
  end
end
