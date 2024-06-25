module Mint
  class Formatter2
    def format(node : Ast::ArrayLiteral) : Nodes
      type =
        format node.type do |item|
          [" of "] + format(item)
        end

      head =
        [
          if node.items.empty?
            "[]"
          else
            Group.new(
              items: node.items.map(&->format(Ast::Node)),
              behavior: Behavior::BreakNotFits,
              ends: {"[", "]"},
              separator: ",",
              pad: true)
          end,
        ] of Node

      head + type
    end
  end
end
