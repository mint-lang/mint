module Mint
  class Formatter
    def format(node : Ast::EnumId)
      expressions =
        unless node.expressions.empty?
          "(#{format(node.expressions, ", ")})"
        end

      "#{node.name}::#{node.option}#{expressions}"
    end
  end
end
