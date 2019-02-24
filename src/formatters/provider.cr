module Mint
  class Formatter
    def format(node : Ast::Provider) : String
      name =
        node.name

      subscription =
        node.subscription

      body =
        list node.functions + node.comments

      comment =
        node.comment.try { |item| "#{format(item)}\n" }

      "#{comment}provider #{name} : #{subscription} {\n#{indent(body)}\n}"
    end
  end
end
