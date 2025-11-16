module Mint
  class Parser
    def expression : Ast::Node?
      return unless expression = base_expression

      expression =
        cast(expression)

      if item = self.operator
        operator, comment =
          item

        pipe operation(expression, operator, comment)
      else
        expression
      end
    end
  end
end
