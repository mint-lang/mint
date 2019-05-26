module Mint
  class Formatter
    def format(node : Ast::Access) : String
      lhs =
        format node.lhs

      safe_operator =
        node.safe ? "&" : ""

      "#{lhs}#{safe_operator}.#{node.field.value}"
    end
  end
end
