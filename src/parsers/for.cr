module Mint
  class Parser
    def for_expression : Ast::For?
      start do |start_position|
        next unless keyword "for"
        next unless whitespace?
        whitespace

        parens = char! '('
        whitespace

        arguments = list(
          terminator: parens ? ')' : '{',
          separator: ','
        ) { variable }

        whitespace
        next error :for_expected_of do
          expected "the of keyword of a for expression", word
          snippet self
        end unless keyword "of"

        whitespace
        next error :for_expected_subject do
          expected "the subject of a for expression", word
          snippet self
        end unless subject = expression

        whitespace
        next error :for_expected_closing_parenthesis do
          expected "the closing parenthesis of a for expression", word
          snippet self
        end if parens && !char!(')')
        whitespace

        body =
          code_block2(
            ->{ error :for_expected_opening_bracket do
              expected "the opening bracket of a for expression", word
              snippet self
            end },
            ->{ error :for_expected_closing_bracket do
              expected "the closing bracket of a for expression", word
              snippet self
            end },
            ->{ error :for_expected_body do
              expected "the body of a for expression", word
              snippet self
            end })

        whitespace
        condition =
          if keyword "when"
            whitespace

            item =
              code_block2(
                ->{ error :for_condition_expected_opening_bracket do
                  expected "the opening bracket of a for condition", word
                  snippet self
                end },
                ->{ error :for_condition_expected_closing_bracket do
                  expected "the closing bracket of a for condition", word
                  snippet self
                end })

            next error :for_condition_expected_body do
              expected "the body of a for condition", word
              snippet self
            end unless item

            item
          end

        self << Ast::For.new(
          condition: condition,
          arguments: arguments,
          from: start_position,
          subject: subject,
          to: position,
          input: data,
          body: body)
      end
    end
  end
end
