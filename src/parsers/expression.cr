module Mint
  class Parser
    def array_access_or_call(lhs)
      case char
      when '.'
        access(lhs)
      when '('
        call(lhs)
      when '['
        array_access(lhs)
      else
        lhs
      end
    end

    def expression : Ast::Expression?
      return unless left = basic_expression

      # Make sure there is no whitespace after an expression
      track_back_whitespace

      # Handle array access
      left = array_access_or_call(left)

      if operator = self.operator
        rollup_pipe operation(left, operator)
      else
        left
      end
    end
  end
end
