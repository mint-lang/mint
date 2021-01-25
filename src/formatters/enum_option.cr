module Mint
  class Formatter
    def format(node : Ast::EnumOption)
      comment =
        node.comment.try { |item| "#{format item}\n" }

      parameters =
        format_parameters(node.parameters)

      "#{comment}#{node.value}#{parameters}"
    end
  end
end
