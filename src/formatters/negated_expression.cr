module Mint
  class Formatter
    def format(node : Ast::NegatedExpression) : String
      expression =
        format node.expression
      "#{node.negations}#{expression}"
    end
  end
end
