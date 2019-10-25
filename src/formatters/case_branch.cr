module Mint
  class Formatter
    def format(node : Ast::CaseBranch) : String
      expression =
        case item = node.expression
        when Array(Ast::CssDefinition)
          list item
        when Ast::Node
          format item
        else
          ""
        end

      match =
        format node.match

      head =
        if match
          "#{match} =>"
        else
          "=>"
        end

      if replace_skipped(expression).includes?("\n")
        "#{head}\n#{indent(expression)}"
      else
        "#{head} #{expression}"
      end
    end
  end
end
