module Mint
  class Formatter
    def format(node : Ast::Access) : String
      lhs =
        format node.lhs

      "#{lhs}.#{node.field.value}"
    end
  end
end
