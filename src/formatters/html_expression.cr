module Mint
  class Formatter
    def format(node : Ast::HtmlExpression) : String
      expression =
        format node.expression

      if expression.includes?("\n")
        "<{\n#{indent(expression)}\n}>"
      else
        "<{ #{expression} }>"
      end
    end
  end
end
