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

      pattern =
        format node.pattern

      head =
        if pattern
          "#{pattern} =>"
        else
          "=>"
        end

      if replace_skipped(expression).includes?('\n') || node.new_line?
        "#{head}\n#{indent(expression)}"
      else
        "#{head} #{expression}"
      end
    end
  end
end
