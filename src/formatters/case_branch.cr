module Mint
  class Formatter
    def format(node : Ast::CaseBranch) : String
      expression =
        format node.expression

      match =
        format node.match

      head =
        if match
          "#{match} =>"
        else
          "=>"
        end

      if expression.includes?("\n")
        "#{head}\n#{indent(expression)}"
      else
        "#{head} #{expression}"
      end
    end
  end
end
