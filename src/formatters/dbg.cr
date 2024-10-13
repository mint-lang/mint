module Mint
  class Formatter
    def format(node : Ast::Dbg) : Nodes
      expression =
        format(node.expression) do |item|
          [" "] + format(item)
        end

      ["dbg"] + expression
    end
  end
end
