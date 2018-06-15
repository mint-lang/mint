module Mint
  class Parser
    syntax_error IfExpectedTruthyOpeningBracket
    syntax_error IfExpectedTruthyClosingBracket
    syntax_error IfExpectedFalsyOpeningBracket
    syntax_error IfExpectedFalsyClosingBracket
    syntax_error IfExpectedOpeningParentheses
    syntax_error IfExpectedClosingParentheses
    syntax_error IfExpectedTruthyExpression
    syntax_error IfExpectedFalsyExpression
    syntax_error IfExpectedCondition
    syntax_error IfExpectedElse

    def if_expression : Ast::If | Nil
      start do |start_position|
        skip unless keyword "if"

        whitespace
        char '(', IfExpectedOpeningParentheses
        condition = expression! IfExpectedCondition
        char ')', IfExpectedClosingParentheses

        truthy = block(
          opening_bracket: IfExpectedTruthyOpeningBracket,
          closing_bracket: IfExpectedTruthyClosingBracket
        ) do
          expression! IfExpectedTruthyExpression
        end

        whitespace
        keyword! "else", IfExpectedElse

        falsy = block(
          opening_bracket: IfExpectedFalsyOpeningBracket,
          closing_bracket: IfExpectedFalsyClosingBracket
        ) do
          expression! IfExpectedFalsyExpression
        end

        Ast::If.new(
          condition: condition.as(Ast::Expression),
          truthy: truthy.as(Ast::Expression),
          falsy: falsy.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
