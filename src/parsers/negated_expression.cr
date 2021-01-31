module Mint
  class Parser
    syntax_error NegatedExpressionExpectedExpression

    def negated_expression : Ast::NegatedExpression?
      start do |start_position|
        negations = gather { chars("!") }.to_s
        skip if negations.empty?
        negations = if negations.size % 2 == 0
                      "!!"
                    else
                      "!"
                    end

        expression = expression! NegatedExpressionExpectedExpression

        self << Ast::NegatedExpression.new(
          expression: expression,
          negations: negations,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
