module Mint
  class Formatter
    def format(node : Ast::Encode)
      expression =
        format node.expression

      "encode #{expression}"
    end
  end
end
