module Mint
  class Parser
    def expression : Ast::Node?
      return unless expression = base_expression

      if operator = self.operator
        pipe operation(expression, operator)
      else
        expression
      end
    end
  end
end
