module Mint
  class Formatter
    def format(node : Ast::SignalValue) : Nodes
      expression =
        format node.expression

      ["~"] + expression
    end
  end
end
