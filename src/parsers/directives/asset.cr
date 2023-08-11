module Mint
  class Parser
    def asset_directive : Ast::Directives::Asset?
      start do |start_position|
        next unless keyword "@asset"

        next error :asset_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an asset directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :asset_directive_expected_path do
          expected "the path of an asset directive", word
          snippet self
        end unless path = gather { chars_until ')' }

        whitespace
        next error :asset_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an asset directive", word
          snippet self
        end unless char! ')'

        self << Ast::Directives::Asset.new(
          from: start_position,
          to: position,
          input: data,
          path: path)
      end
    end
  end
end
