module Mint
  class Formatter
    def format(node : Ast::Store) : String
      items =
        node.properties +
          node.functions +
          node.gets

      name =
        format node.name

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}store #{name} {\n#{body.indent}\n}"
    end
  end
end
