module Mint
  class Formatter
    def format(node : Ast::Decode)
      type =
        format node.type

      expression =
        if item = node.expression
          " #{format(item)}"
        end

      "decode#{expression} as #{type}"
    end
  end
end
