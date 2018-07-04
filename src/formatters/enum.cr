module Mint
  class Formatter
    def format(node : Ast::Enum)
      name =
        format node.name

      items =
        node.options + node.comments

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}enum #{name} {\n#{body.indent}\n}"
    end
  end
end
