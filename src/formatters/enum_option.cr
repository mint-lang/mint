module Mint
  class Formatter
    def format(node : Ast::EnumOption)
      comment =
        node.comment.try { |item| "#{format item}\n" }

      "#{comment}#{node.value}"
    end
  end
end
