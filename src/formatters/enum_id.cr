module Mint
  class Formatter
    def format(node : Ast::EnumId)
      expressions =
        if node.expressions.empty?
          ""
        elsif node.new_line?
          "(\n#{indent(format(node.expressions, ",\n"))}\n)"
        else
          "(#{format(node.expressions, ", ")})"
        end

      "#{node.name}::#{node.option}#{expressions}"
    end
  end
end
