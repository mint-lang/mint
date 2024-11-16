module Mint
  class Formatter
    def format(node : Ast::Dbg) : Nodes
      expression =
        format(node.expression) do |item|
          [" "] + format(item)
        end

      bang =
        if node.bang?
          "!"
        else
          ""
        end

      ["dbg", bang] + expression
    end
  end
end
