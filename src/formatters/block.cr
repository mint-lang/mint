module Mint
  class Formatter
    enum BlockFormat
      Attribute
      Inline
      Naked
      Block
    end

    def format(node : Ast::Block, format = BlockFormat::Block) : String
      body =
        list node.expressions

      if format == BlockFormat::Naked
        body
      else
        if format == BlockFormat::Block || replace_skipped(body).includes?('\n') || node.new_line?
          "{\n#{indent(body)}\n}"
        else
          case format
          when BlockFormat::Attribute
            "{#{body}}"
          when BlockFormat::Inline
            "{ #{body} }"
          else
            "{#{body}}"
          end
        end
      end
    end
  end
end
