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

      if format == BlockFormat::Naked
        body
      elsif format == BlockFormat::Block
        group(
          behavior: Behavior::Block,
          ends: {"{", "}"},
          separator: "",
          items: [body],
          pad: false)
      else
        case format
        when BlockFormat::Attribute,
             BlockFormat::Inline
          group(
            pad: format == BlockFormat::Inline,
            behavior: Behavior::BreakAll,
            ends: {"{", "}"},
            items: [body],
            separator: "")
        else
          ["{"] + body + ["}"]
        end
      end
    end
  end
end
