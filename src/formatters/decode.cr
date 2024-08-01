module Mint
  class Formatter
    def format(node : Ast::Decode) : Nodes
      type =
        format node.type

      expression =
        format(node.expression) do |item|
          [" "] + format(item)
        end

      ["decode"] + expression + [" as "] + type
    end
  end
end
