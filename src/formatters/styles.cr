module Mint
  class Formatter
    def format(node : Ast::Styles) : String
      items =
        node.comments +
          node.styles

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}styles #{node.name} {\n#{indent(body)}\n}"
    end
  end
end
