module Mint
  class Formatter
    def format(node : Ast::EnumOption)
      comment =
        node.comment.try { |item| "#{format item}\n" }

      parameters =
        if node.parameters.any?
          "(#{format(node.parameters, ", ")})"
        end

      "#{comment}#{node.value}#{parameters}"
    end
  end
end
