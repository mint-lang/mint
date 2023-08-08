module Mint
  class Parser
    def documentation_directive : Ast::Directives::Documentation?
      parse do |start_position|
        next unless word! "@documentation"

        next error :documentation_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of a documentation directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :documentation_directive_expected_entity do
          expected "the entity (component, module, etc...) of a documentation directive", word
          snippet self
        end unless entity = id
        whitespace

        next error :documentation_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of a documentation directive", word
          snippet self
        end unless char! ')'

        Ast::Directives::Documentation.new(
          from: start_position,
          entity: entity,
          to: position,
          file: file)
      end
    end
  end
end
