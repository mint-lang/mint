module Mint
  class Formatter
    def format(node : Ast::Decode)
      expression =
        format node.expression

      type =
        format node.type

      "decode #{expression} as #{type}"
    end
  end
end
