module Mint
  class Formatter
    def format(node : Ast::Get) : String
      name =
        format node.name

      type =
        format node.type

      body =
        list [node.body] + node.head_comments + node.tail_comments

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}get #{name} : #{type} {\n#{body.indent}\n}"
    end
  end
end
