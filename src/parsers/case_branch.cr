module Mint
  class Parser
    def case_branch(*, for_css : Bool = false) : Ast::CaseBranch?
      parse do |start_position|
        unless word! "=>"
          patterns = list(separator: '|', terminator: '=') { destructuring }
          whitespace
          next unless word! "=>"
        end

        whitespace

        expression =
          if for_css
            if char == '{'
              brackets { many { css_definition } }
            else
              many { css_definition }
            end
          else
            self.expression
          end

        next error :case_branch_expected_expression do
          snippet(
            "A case branch must have an value, here is an example:",
            "=> value")

          expected "the value of a case branch", word
          snippet self
        end unless expression

        Ast::CaseBranch.new(
          expression: expression,
          from: start_position,
          patterns: patterns,
          to: position,
          file: file)
      end
    end
  end
end
