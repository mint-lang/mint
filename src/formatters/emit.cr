module Mint
  class Formatter
    def format(node : Ast::Emit) : String
      expression =
        format node.expression

      "emit #{expression}"
    end
  end
end
