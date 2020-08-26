module Mint
  class Formatter
    def format(node : Ast::EnumId)
      expressions =
        case
        when node.expressions.empty?
          ""
        when node.new_line?
          "(\n#{indent(format(node.expressions, ",\n"))})"
        else
          "(#{format(node.expressions, ", ")})"
        end

      "#{node.name}::#{node.option}#{expressions}"
    end
  end
end
