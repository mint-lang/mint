module Mint
  class Formatter
    def format(node : Ast::Access) : String
      expression =
        format node.expression

      "#{expression}.#{node.field.value}"
    end
  end
end
