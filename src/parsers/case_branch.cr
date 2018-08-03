module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch : Ast::CaseBranch | Nil
      start do |start_position|
        unless keyword "=>"
          match = expression
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        expression = self.expression || enum_option

        raise CaseBranchExpectedExpression unless expression

        Ast::CaseBranch.new(
          expression: expression.as(Ast::Expression | Ast::EnumOption),
          from: start_position,
          to: position,
          match: match,
          input: data)
      end
    end
  end
end
