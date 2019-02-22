module Mint
  class Formatter
    def format(node : Ast::Component) : String
      items =
        node.properties +
          node.connects +
          node.styles +
          node.states +
          node.functions +
          node.gets +
          node.uses +
          node.comments

      name =
        format node.name

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}component #{name} {\n#{indent(body)}\n}"
    end
  end
end
