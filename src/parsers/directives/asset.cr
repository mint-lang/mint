module Mint
  class Parser
    def asset_directive : Ast::Directives::Asset?
      parse do |start_position|
        next unless keyword! "@asset"

        next error :asset_directive_expected_opening_parenthesis do
          expected "the opening parenthesis of an asset directive", word
          snippet self
        end unless char! '('
        whitespace

        next error :asset_directive_expected_path do
          expected "the path (to the asset) of an asset directive", word
          snippet self
        end unless path = gather { chars { char != ')' } }.presence.try(&.strip)
        whitespace

        next error :asset_directive_expected_closing_parenthesis do
          expected "the closing parenthesis of an asset directive", word
          snippet self
        end unless char! ')'

        Ast::Directives::Asset.new(
          from: start_position,
          to: position,
          file: file,
          path: path)
      end
    end
  end
end
