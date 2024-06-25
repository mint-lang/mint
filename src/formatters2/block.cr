module Mint
  class Formatter2
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
        ["{", Indent.new([:ln] + body), :ln, "}"] of Node
      else
        case format
        when BlockFormat::Attribute
          ["{"] + body + ["}"] of Node
        when BlockFormat::Inline
          ["{ "] + body + [" }"] of Node
        else
          ["{"] + body + ["}"] of Node
        end
      end
    end
  end
end
