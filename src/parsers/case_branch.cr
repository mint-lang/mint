module Mint
  class Parser
    def case_branch(for_css : Bool = false) : Ast::CaseBranch?
      start do |start_position|
        unless keyword "=>"
          match = destructuring
          whitespace
          next unless keyword "=>"
        end

        whitespace

        expression =
          if for_css
            many { css_definition }
          else
            next error :case_branch_expected_expression do
              block do
                text "A case branch must have an expression."
              end

              expected "the body of a case expression", word
              snippet self
            end unless item = self.expression

            item
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
