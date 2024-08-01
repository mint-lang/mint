module Mint
  class Formatter
    def format(node : Ast::ArrayLiteral) : Nodes
      type =
        format node.type do |item|
          [" of "] + format(item)
        end

      head =
        if node.items.empty?
          format("[]")
        else
          group(
            items: node.items.map(&->format(Ast::Node)),
            behavior: Behavior::BreakAll,
            ends: {"[", "]"},
            separator: ",",
            pad: false)
        end

      head + type
    end
  end
end
