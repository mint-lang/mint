module Mint
  class Formatter
    def format(node : Ast::HtmlAttribute) : String
      name =
        format node.name

      formatted =
        case value = node.value
        when Ast::Block
          format value, BlockFormat::Attribute
        else
          format value
        end

      case node.value
      when Ast::StringLiteral
        if replace_skipped(formatted).includes?('\n')
          "#{name}={\n#{indent(formatted)}\n}"
        else
          "#{name}=#{formatted}"
        end
      else
        "#{name}=#{formatted}"
      end
    end
  end
end
