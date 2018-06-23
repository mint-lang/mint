module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch : Ast::CaseBranch | Nil
      start do |start_position|
        comment = self.comment

        unless keyword "=>"
          match = expression
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        expression = expression! CaseBranchExpectedExpression

        Ast::CaseBranch.new(
          expression: expression.as(Ast::Expression),
          from: start_position,
          comment: comment,
          to: position,
          match: match,
          input: data)
      end
    end
  end
end
