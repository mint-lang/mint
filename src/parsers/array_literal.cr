module Mint
  class Parser
    def array : Ast::ArrayLiteral?
      start do |start_position|
        next unless char! '['

        whitespace
        items = list(
          terminator: ']',
          separator: ','
        ) { expression }
        whitespace

        whitespace
        next error :array_expected_closing_bracket do
          expected "the closing bracket of an array", word
          snippet self
        end unless char! ']'

        type = start do
          whitespace
          next unless keyword "of"
          whitespace

          next error :array_literal_expected_type_or_variable do
            block do
              text "The type of an"
              bold "array literal"
              text "must be defined after the"
              bold "of"
              text "keyword."
            end

            expected "the type", word
            snippet self
          end unless item = type_or_type_variable

          item
        end

        self << Ast::ArrayLiteral.new(
          from: start_position,
          items: items,
          type: type,
          to: position,
          input: data)
      end
    end
  end
end
