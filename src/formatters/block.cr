module Mint
  class Formatter
    enum BlockFormat
      Outdented
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

      case format
      in BlockFormat::Naked
        body
      in BlockFormat::Outdented
        group(
          behavior: Behavior::Outdented,
          ends: {"{", "}"},
          separator: "",
          items: [body],
          pad: false) + fallback
      in BlockFormat::Block
        group(
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: "",
          items: [body],
          pad: false) + fallback
      in BlockFormat::Attribute,
         BlockFormat::Inline
        group(
          pad: format == BlockFormat::Inline,
          behavior: Behavior::BreakAll,
          ends: {"{", "}"},
          items: [body],
          separator: "") + fallback
      end
    end
  end
end
