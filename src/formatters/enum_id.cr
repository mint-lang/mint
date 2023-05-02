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

      if node.name
        "#{format node.name}::#{format node.option}#{expressions}"
      else
        "#{format node.option}#{expressions}"
      end
    end
  end
end
