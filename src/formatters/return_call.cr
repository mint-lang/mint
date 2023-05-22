module Mint
  class Formatter
    def format(node : Ast::ReturnCall) : String
      expression =
        format node.expression

      "return #{expression}"
    end
  end
end
