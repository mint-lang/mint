module Mint
  class Formatter
    def format(node : Ast::Module) : String
      body =
        list node.functions + node.comments

      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}module #{node.name} {\n#{indent(body)}\n}"
    end
  end
end
