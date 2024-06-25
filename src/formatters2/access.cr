module Mint
  class Formatter2
    def format(node : Ast::Access) : Nodes
      expression =
        format node.expression

      expression + [".", node.field.value]
    end
  end
end
