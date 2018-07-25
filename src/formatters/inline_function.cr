module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : String
      body =
        list [node.body] + node.head_comments + node.tail_comments

      arguments =
        format node.arguments, ", "

      type =
        format node.type

      if body.includes?("\n")
        "(#{arguments}) : #{type} => {\n#{body.indent}\n}"
      else
        "(#{arguments}) : #{type} => { #{body} }"
      end
    end
  end
end
