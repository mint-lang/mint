module Mint
  class Formatter
    def format(node : Ast::HtmlAttribute) : Nodes
      name =
        format node.name

      formatted =
        case value = node.value
        when Ast::Block
          format value, BlockFormat::Attribute
        else
          format value
        end

      name + ["="] + formatted
    end
  end
end
