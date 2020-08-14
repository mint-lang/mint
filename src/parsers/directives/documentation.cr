module Mint
  class Parser
    syntax_error DocumentationDirectiveExpectedClosingParentheses
    syntax_error DocumentationDirectiveExpectedOpeningParentheses
    syntax_error DocumentationDirectiveExpectedEntity

    def documentation_directive : Ast::Directives::Documentation?
      start do |start_position|
        skip unless keyword "@documentation"

        char '(', DocumentationDirectiveExpectedOpeningParentheses
        whitespace
        entity = type_id! DocumentationDirectiveExpectedEntity
        whitespace
        char ')', DocumentationDirectiveExpectedClosingParentheses

        Ast::Directives::Documentation.new(
          from: start_position,
          entity: entity,
          to: position,
          input: data)
      end
    end
  end
end
