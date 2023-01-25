module Mint
  class Formatter
    def format(node : Ast::HtmlAttribute) : String
      name =
        format node.name

      value =
        case x = node.value
        when Ast::Block
          format x, BlockFormat::Attribute
        else
          format node.value
        end

      case node.value
      when Ast::StringLiteral
        if replace_skipped(value).includes?('\n')
          "#{name}={\n#{indent(value)}\n}"
        else
          "#{name}=#{value}"
        end
      else
        "#{name}=#{value}"
      end
    end
  end
end
