module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : String
      body =
        list [node.body] + node.head_comments + node.tail_comments

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
