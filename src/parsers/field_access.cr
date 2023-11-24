module Mint
  class Parser
    def field_access : Ast::FieldAccess?
      parse do |start_position|
        next unless char! '.'

        next error :field_access_expected_variable do
          expected "the field of the accessed entity of a field access", word
          snippet self
        end unless name = variable

        whitespace
        next error :field_access_expected_opening_parenthesis do
          expected "the opening parenthesis of a field access", word
          snippet self
        end unless char! '('

        whitespace
        next error :field_access_expected_type do
          expected "the type of a field access", word
          snippet self
        end unless type = self.type

        whitespace
        next error :field_access_expected_closing_parenthesis do
          expected "the closing parentheses of a field access", word
          snippet self
        end unless char! ')'

        Ast::FieldAccess.new(
          from: start_position,
          to: position,
          type: type,
          file: file,
          name: name)
      end
    end
  end
end
