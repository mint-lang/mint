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

    def if_expression(for_css = false, for_html = false) : Ast::If?
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
            if for_css
              many { css_definition }.compact
            else
              expression! IfExpectedTruthyExpression
            end
          end

        falsy_head_comments = [] of Ast::Comment
        falsy_tail_comments = [] of Ast::Comment
        falsy = nil

        whitespace

        if (!for_css && !for_html) || keyword_ahead "else"
          keyword! "else", IfExpectedElse
          whitespace

          unless falsy = if_expression(for_css: for_css, for_html: for_html)
            falsy_head_comments, falsy, falsy_tail_comments =
              block_with_comments(
                opening_bracket: IfExpectedFalsyOpeningBracket,
                closing_bracket: IfExpectedFalsyClosingBracket
              ) do
                if for_css
                  many { css_definition }.compact
                else
                  expression! IfExpectedFalsyExpression
                end
              end
          end
        end

        self << Ast::If.new(
          truthy_head_comments: truthy_head_comments,
          truthy_tail_comments: truthy_tail_comments,
          falsy_head_comments: falsy_head_comments,
          falsy_tail_comments: falsy_tail_comments,
          condition: condition,
          branches: {truthy, falsy},
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
