module Mint
  class Formatter
    def format(node : Ast::HtmlExpression) : String
      expression =
        format node.expression

      case node.expression
      when Ast::If, Ast::For, Ast::StringLiteral, Ast::With, Ast::Case, Ast::Try, Ast::ArrayLiteral
        expression
      else
        if replace_skipped(expression).includes?("\n")
          "<{\n#{indent(expression)}\n}>"
        else
          "<{ #{expression} }>"
        end
      end
    end
  end
end
