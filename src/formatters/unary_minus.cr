module Mint
  class Formatter
    def format(node : Ast::UnaryMinus) : String
      expression =
        format node.expression

      "-#{expression}"
    end
  end
end
