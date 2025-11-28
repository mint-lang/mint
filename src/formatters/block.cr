module Mint
  class Formatter
    enum BlockFormat
      Attribute
      Inline
      Naked
      Block
    end

    def format(node : Ast::Block, format = BlockFormat::Block) : Nodes
      body =
        list node.expressions

      fallback =
        if item = node.fallback
          [" or "] + format(item)
        else
          [] of Node
        end

      if format == BlockFormat::Naked
        body
      elsif format == BlockFormat::Block
        group(
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: "",
          items: [body],
          pad: false) + fallback
      else
        case format
        when BlockFormat::Attribute,
             BlockFormat::Inline
          group(
            pad: format == BlockFormat::Inline,
            behavior: Behavior::BreakAll,
            ends: {"{", "}"},
            items: [body],
            separator: "") + fallback
        else
          ["{"] + body + ["}"] + fallback
        end
      end
    end
  end
end
