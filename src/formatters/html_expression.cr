module Mint
  class Formatter
    def format(node : Ast::HtmlExpression) : String
      expressions =
        list node.expressions

      if replace_skipped(expressions).includes?('\n')
        "<{\n#{indent(expressions)}\n}>"
      else
        "<{ #{expressions} }>"
      end
    end
  end
end
