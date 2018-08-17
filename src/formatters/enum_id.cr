module Mint
  class Formatter
    def format(node : Ast::EnumId)
      expressions =
        if node.expressions.any?
          "(#{format(node.expressions, ", ")})"
        end

      "#{node.name}::#{node.option}#{expressions}"
    end
  end
end
