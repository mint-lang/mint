module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : String
      body =
        format node.body

      arguments =
        format node.arguments, ", "

      if body.includes?("\n")
        "\\#{arguments} =>\n#{body.indent}"
      else
        "\\#{arguments} => #{body}"
      end
    end
  end
end
