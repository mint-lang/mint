module Mint
  class Parser
    def case_branch(*, for_css : Bool = false) : Ast::CaseBranch?
      parse do |start_position|
        unless word! "=>"
          pattern = destructuring
          whitespace

          next unless word! "=>"
        end

        whitespace

        expression =
          if for_css
            many { css_definition }
          else
            next error :case_branch_expected_expression do
              snippet(
                "A case branch must have an value, here is an example:",
                "=> value")

              expected "the value of a case branch", word
              snippet self
            end unless item = self.expression

            item
          end

        Ast::CaseBranch.new(
          expression: expression,
          from: start_position,
          pattern: pattern,
          to: position,
          file: file)
      end
    end
  end
end
