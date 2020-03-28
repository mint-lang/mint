module Mint
  class Formatter
    def format(node : Ast::HtmlAttribute) : String
      name =
        format node.name

      value =
        format node.value

      case node.value
      when Ast::StringLiteral
        if replace_skipped(value).includes?('\n')
          "#{name}={\n#{indent(value)}\n}"
        else
          "#{name}=#{value}"
        end
      when Ast::ArrayLiteral
        "#{name}=#{value}"
      else
        if replace_skipped(value).includes?('\n')
          "#{name}={\n#{indent(value)}\n}"
        else
          "#{name}={#{value}}"
        end
      end
    end
  end
end
