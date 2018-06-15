module Mint
  class Parser
    syntax_error CaseExpectedOpeningParentheses
    syntax_error CaseExpectedClosingParentheses
    syntax_error CaseExpectedOpeningBracket
    syntax_error CaseExpectedClosingBracket
    syntax_error CaseExpectedCondition
    syntax_error CaseExpectedBranches

    def case_expression : Ast::Case | Nil
      start do |start_position|
        skip unless keyword "case"

        whitespace

        char '(', CaseExpectedOpeningParentheses

        whitespace
        condition = expression! CaseExpectedCondition
        whitespace

        char ')', CaseExpectedClosingParentheses

        branches = block(
          opening_bracket: CaseExpectedOpeningBracket,
          closing_bracket: CaseExpectedClosingBracket
        ) do
          items = many { case_branch }.compact
          raise CaseExpectedBranches if items.empty?
          items
        end

        Ast::Case.new(
          condition: condition.as(Ast::Expression),
          from: start_position,
          branches: branches,
          to: position,
          input: data)
      end
    end
  end
end
