module Mint
  class Parser
    def if_expression(for_css = false) : Ast::If?
      parse do |start_position|
        next unless keyword! "if"
        whitespace

        parens = char! '('
        whitespace

        next error :if_expected_condition do
          expected "the condition", word
          snippet self
        end unless condition = statement || expression
        whitespace

        next error :if_expected_closing_parenthesis do
          expected "the closing parenthesis of the condition of an if expression", word
          snippet self
        end if parens && !char!(')')
        whitespace

        truthy =
          block(
            ->{ error :if_expected_truthy_opening_bracket do
              expected "the opening bracket of the truthy branch", word
              snippet self
            end },
            ->{ error :if_expected_truthy_closing_bracket do
              expected "the closing bracket of the truthy branch", word
              snippet self
            end },

            ->{ error :if_expected_truthy_expression do
              expected "an expression for the truthy branch", word
              snippet self
            end }) { for_css ? css_definition : comment || statement }

        next unless truthy

        falsy = nil
        whitespace

        if keyword! "else"
          whitespace

          unless falsy = if_expression(for_css: for_css)
            falsy =
              block(
                ->{ error :if_expected_else_opening_bracket do
                  expected "the opening bracket of the else branch", word
                  snippet self
                end },
                ->{ error :if_expected_else_closing_bracket do
                  expected "the closing bracket of the else branch", word
                  snippet self
                end },
                ->{ error :if_expected_else_expression do
                  expected "an expression for the else branch", word
                  snippet self
                end }) { for_css ? css_definition : comment || statement }

            next unless falsy
          end
        end

        Ast::If.new(
          branches: {truthy, falsy},
          condition: condition,
          from: start_position,
          to: position,
          file: file
        ).tap do |node|
          case condition
          when Ast::Statement
            condition.if_node = node
          end
        end
      end
    end
  end
end
