module Mint
  class Parser
    syntax_error CaseExpectedClosingParentheses
    syntax_error CaseExpectedOpeningBracket
    syntax_error CaseExpectedClosingBracket
    syntax_error CaseExpectedCondition
    syntax_error CaseExpectedBranches

    def case_expression(for_css : Bool = false) : Ast::Case?
      start do |start_position|
        next unless keyword "case"

        whitespace

        parens = char! '('

        whitespace
        await = keyword "await"

        whitespace
        condition = expression! CaseExpectedCondition
        whitespace

        char ')', CaseExpectedClosingParentheses if parens

        body = block(
          opening_bracket: CaseExpectedOpeningBracket,
          closing_bracket: CaseExpectedClosingBracket
        ) do
          items = many { case_branch(for_css) || comment }
          raise CaseExpectedBranches if items.empty?
          items
        end

        branches = [] of Ast::CaseBranch
        comments = [] of Ast::Comment

        body.each do |item|
          case item
          when Ast::CaseBranch
            branches << item
          when Ast::Comment
            comments << item
          end
        end

        self << Ast::Case.new(
          condition: condition,
          from: start_position,
          branches: branches,
          comments: comments,
          await: await,
          to: position,
          input: data)
      end
    end
  end
end
