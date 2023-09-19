module Mint
  class Formatter
    def format(node : Ast::ArrayAccess) : String
      index =
        format node.index

      expression =
        format node.expression

      "#{expression}[#{index}]"
    end
  end
end
