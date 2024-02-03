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
          node.comments +
          node.constants

      name =
        format node.name

      body =
        list items

      global =
        node.global? ? "global " : ""

      async =
        node.async? ? "async " : ""

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}#{async}#{global}component #{name} {\n#{indent(body)}\n}"
    end
  end
end
