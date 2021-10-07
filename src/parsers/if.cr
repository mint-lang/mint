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
        next unless keyword "if"

        whitespace
        char '(', IfExpectedOpeningParentheses
        whitespace
        condition = expression! IfExpectedCondition
        whitespace
        char ')', IfExpectedClosingParentheses
        whitespace

        truthy =
          if for_css
            block(
              opening_bracket: IfExpectedTruthyOpeningBracket,
              closing_bracket: IfExpectedTruthyClosingBracket) do
              many { css_definition }
            end
          else
            code_block(
              opening_bracket: IfExpectedTruthyOpeningBracket,
              closing_bracket: IfExpectedTruthyClosingBracket,
              statement_error: IfExpectedTruthyExpression)
          end

        raise IfExpectedTruthyExpression unless truthy

        falsy = nil
        whitespace

        if (!for_css && !for_html) || keyword_ahead "else"
          keyword! "else", IfExpectedElse
          whitespace

          unless falsy = if_expression(for_css: for_css, for_html: for_html)
            falsy =
              if for_css
                block(
                  opening_bracket: IfExpectedFalsyOpeningBracket,
                  closing_bracket: IfExpectedFalsyClosingBracket) do
                  many { css_definition }
                end
              else
                code_block(
                  opening_bracket: IfExpectedFalsyOpeningBracket,
                  closing_bracket: IfExpectedFalsyClosingBracket,
                  statement_error: IfExpectedFalsyExpression)
              end

            raise IfExpectedFalsyExpression unless falsy
          end
        end

        self << Ast::If.new(
          branches: {truthy, falsy},
          condition: condition,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
