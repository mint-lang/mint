module Mint
  class Parser
    syntax_error CaseBranchExpectedExpression

    def case_branch(for_css : Bool = false) : Ast::CaseBranch?
      start do |start_position|
        unless keyword "=>"
          match =
            constant_access ||
              enum_destructuring ||
              bool_tuple_literal ||
              tuple_destructuring ||
              array_destructuring ||
              expression
          whitespace
          skip unless keyword "=>"
        end

        whitespace

        expression =
          if for_css
            many { css_definition }.compact
          else
            expression! CaseBranchExpectedExpression
          end

        self << Ast::CaseBranch.new(
          match: match.as(Ast::EnumDestructuring | Ast::TupleDestructuring | Ast::Expression?),
          expression: expression,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
