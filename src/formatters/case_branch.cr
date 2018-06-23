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

      comment =
        node.comment.try { |item| "#{format item}\n" }

      if expression.includes?("\n")
        "#{comment}#{head}\n#{expression.indent}"
      else
        "#{comment}#{head} #{expression}"
      end
    end
  end
end
