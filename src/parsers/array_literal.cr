module Mint
  class Parser
    def array_literal : Ast::ArrayLiteral?
      parse do |start_position|
        next unless char! '['
        whitespace

        items = list(
          terminator: ']',
          separator: ','
        ) { expression }
        whitespace

        next error :array_expected_closing_bracket do
          expected "the closing bracket of an array", word
          snippet self
        end unless char! ']'

        type =
          parse(track: false) do
            whitespace
            next unless keyword! "of"

            whitespace
            next error :array_expected_type_or_variable do
              block do
                text "The type of an"
                bold "array literal"
                text "must be defined after the"
                bold "of"
                text "keyword, here is an example:"
              end

              snippet "[] of String"
              expected "the type", word
              snippet self
            end unless item = self.type || type_variable

            item
          end

        Ast::ArrayLiteral.new(
          from: start_position,
          items: items,
          to: position,
          type: type,
          file: file)
      end
    end
  end
end
