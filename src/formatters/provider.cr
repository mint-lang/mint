module Mint
  class Formatter
    def format(node : Ast::Provider) : String
      name =
        node.name

      subscription =
        node.subscription

      body =
        list node.functions + node.comments + node.states + node.gets + node.constants

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}provider #{format name} : #{format subscription} {\n#{indent(body)}\n}"
    end
  end
end
