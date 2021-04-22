module Mint
  class Parser
    syntax_error AssetDirectiveExpectedOpeningParentheses
    syntax_error AssetDirectiveExpectedClosingParentheses
    syntax_error AssetDirectiveExpectedPath

    def inline_directive : Ast::Directives::Inline?
      start do |start_position|
        skip unless keyword "@inline"

        char '(', AssetDirectiveExpectedOpeningParentheses
        whitespace

        path = gather { chars "^)" }
        raise AssetDirectiveExpectedPath unless path

        whitespace
        char ')', AssetDirectiveExpectedClosingParentheses

        self << Ast::Directives::Inline.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
