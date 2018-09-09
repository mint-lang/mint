module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch : Ast::CaseBranch | Nil
      start do |start_position|
        unless keyword "=>"
          match = enum_destructuring || expression
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        raise CaseBranchExpectedExpression unless expression = self.expression

        Ast::CaseBranch.new(
          match: match.as(Ast::EnumDestructuring | Ast::Expression | Nil),
          expression: expression.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
