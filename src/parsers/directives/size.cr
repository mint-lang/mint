module Mint
  class Parser
    def size_directive : Ast::Directives::Size?
      parse do |start_position|
        next unless keyword! "@size"

        next error :size_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of size directive", word
          snippet self
        end unless char!('(')
        whitespace

        next error :size_directive_expected_ref do
          expected "the variable to the reference element of a size directive", word
          snippet self
        end unless ref = variable

        whitespace
        next error :size_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of size directive", word
          snippet self
        end unless char!(')')

        Ast::Directives::Size.new(
          from: start_position,
          to: position,
          file: file,
          ref: ref)
      end
    end
  end
end
