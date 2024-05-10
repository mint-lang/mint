module Mint
  class Formatter
    def format(node : Ast::Provider) : String
      items =
        node.functions +
          node.constants +
          node.comments +
          node.signals +
          node.states +
          node.gets

      subscription =
        node.subscription

      name =
        node.name

      body =
        list items

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}provider #{format name} : #{format subscription} {\n#{indent(body)}\n}"
    end
  end
end
