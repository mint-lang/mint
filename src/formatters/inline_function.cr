module Mint
  class Formatter
    def format(node : Ast::InlineFunction) : String
      body =
        list [node.body] + node.head_comments + node.tail_comments

      value =
        format node.arguments

      arguments =
        if value.map(&.size).sum > 50
          "\n#{indent(value.join(",\n"))}\n"
        else
          value.join(", ")
        end

      type =
        format node.type

      if body.includes?("\n") ||
         arguments.includes?("\n") ||
         ast.has_new_line?(node.type, node.body)
        "(#{arguments}) : #{type} {\n#{indent(body)}\n}"
      else
        "(#{arguments}) : #{type} { #{body} }"
      end
    end
  end
end
