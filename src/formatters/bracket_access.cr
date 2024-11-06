module Mint
  class Formatter
    def format(node : Ast::BracketAccess) : Nodes
      expression =
        format node.expression

      index =
        format node.index

      expression + ["["] + index + ["]"]
    end
  end
end
