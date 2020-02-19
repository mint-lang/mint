module Mint
  class Formatter
    def format(node : Ast::Store) : String
      items =
        node.functions +
          node.comments +
          node.states +
          node.gets +
          node.constants

      name =
        format node.name

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}store #{name} {\n#{indent(body)}\n}"
    end
  end
end
