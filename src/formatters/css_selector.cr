module Mint
  class Formatter
    def format(node : Ast::CssSelector) : Nodes
      items =
        node.selectors.map do |item|
          if item.starts_with?(' ')
            format(item.lstrip)
          else
            format("&#{item}")
          end
        end

      selectors =
        group(
          behavior: Behavior::BreakNotFits,
          separator: ",",
          ends: {"", ""},
          items: items,
          pad: false)

      body =
        group(
          behavior: Behavior::Block,
          items: [list(node.body)],
          ends: {"{", "}"},
          separator: "",
          pad: false)

      selectors + [" "] + body
    end
  end
end
