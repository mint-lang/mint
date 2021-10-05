module Mint
  class Formatter
    def format(node : Ast::Get) : String
      name =
        format node.name

      type =
        node.type.try do |item|
          " : #{format(item)}"
        end

      body =
        list [node.body] + node.head_comments + node.tail_comments

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}get #{name}#{type} {\n#{indent(body)}\n}"
    end
  end
end
