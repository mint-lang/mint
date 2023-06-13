module Mint
  class Parser
    syntax_error AssetDirectiveExpectedOpeningParentheses
    syntax_error AssetDirectiveExpectedClosingParentheses
    syntax_error AssetDirectiveExpectedPath

    def asset_directive : Ast::Directives::Asset?
      start do |start_position|
        next unless keyword "@asset"

        char '(', AssetDirectiveExpectedOpeningParentheses
        whitespace

        path = gather { chars_until ')' }
        raise AssetDirectiveExpectedPath unless path

        whitespace
        char ')', AssetDirectiveExpectedClosingParentheses

        self << Ast::Directives::Asset.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
