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
        whitespace
        condition = expression! IfExpectedCondition
        whitespace
        char ')', IfExpectedClosingParentheses

        truthy_head_comments, truthy, truthy_tail_comments =
          block_with_comments(
            opening_bracket: IfExpectedTruthyOpeningBracket,
            closing_bracket: IfExpectedTruthyClosingBracket
          ) do
            expression! IfExpectedTruthyExpression
          end

        whitespace
        keyword! "else", IfExpectedElse
        whitespace

        if falsy = if_expression
          falsy_head_comments = [] of Ast::Comment
          falsy_tail_comments = [] of Ast::Comment
        else
          falsy_head_comments, falsy, falsy_tail_comments =
            block_with_comments(
              opening_bracket: IfExpectedFalsyOpeningBracket,
              closing_bracket: IfExpectedFalsyClosingBracket
            ) do
              expression! IfExpectedFalsyExpression
            end
        end

        Ast::If.new(
          truthy_head_comments: truthy_head_comments,
          truthy_tail_comments: truthy_tail_comments,
          falsy_head_comments: falsy_head_comments,
          falsy_tail_comments: falsy_tail_comments,
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
