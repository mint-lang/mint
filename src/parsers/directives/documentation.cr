module Mint
  class Parser
    def documentation_directive : Ast::Directives::Documentation?
      start do |start_position|
        next unless keyword "@documentation"

        next error :documentation_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of a documentation directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :documentation_directive_expected_entity do
          expected "the entity of a documentation directive", word
          snippet self
        end unless entity = type_id
        whitespace

        next error :documentation_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of a documentation directive", word
          snippet self
        end unless char! ')'

        self << Ast::Directives::Documentation.new(
          from: start_position,
          entity: entity,
          to: position,
          input: data)
      end
    end
  end
end
