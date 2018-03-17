class Formatter
  def format(node : Ast::HtmlAttribute) : String
    name =
      format node.name

    value =
      format node.value

    case node.value
    when Ast::StringLiteral
      if value.includes?("\n")
        "#{name}={\n#{value.indent}\n}"
      else
        "#{name}=#{value}"
      end
    else
      if value.includes?("\n")
        "#{name}={\n#{value.indent}\n}"
      else
        "#{name}={#{value}}"
      end
    end
  end
end
