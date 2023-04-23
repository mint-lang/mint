module Mint
  class Formatter
    def format(node : Ast::Module) : String
      items =
        node.functions +
          node.comments +
          node.constants

      body =
        list items

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}module #{format node.name} {\n#{indent(body)}\n}"
    end
  end
end
