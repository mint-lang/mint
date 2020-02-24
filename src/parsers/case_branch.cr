module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch(for_css : Bool = false) : Ast::CaseBranch | Nil
      start do |start_position|
        unless keyword "=>"
          match = enum_destructuring || tuple_destructuring || expression
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        expression =
          if for_css
            many { css_definition }.compact
          else
            self.expression! CaseBranchExpectedExpression
          end

        Ast::CaseBranch.new(
          match: match.as(Ast::EnumDestructuring | Ast::TupleDestructuring | Ast::Expression | Nil),
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
