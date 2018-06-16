module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch : Ast::CaseBranch | Nil
      start do |start_position|
        unless keyword "=>"
          match = expression || type
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        expression = expression! CaseBranchExpectedExpression

        Ast::CaseBranch.new(
          expression: expression,
          from: start_position,
          to: position,
          match: match,
          input: data)
      end
    end
  end
end
