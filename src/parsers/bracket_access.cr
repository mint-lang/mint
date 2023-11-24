module Mint
  class Parser
    def bracket_access(expression : Ast::Node) : Ast::BracketAccess?
      parse do |start_position|
        next unless char! '['
        whitespace

        next error :bracket_access_expected_index do
          expected "the index of a bracket access", word
          snippet self
        end unless index = self.expression
        whitespace

        next error :bracket_access_expected_closing_bracket do
          expected "the closing bracket of a bracket access", word
          snippet self
        end unless char! ']'

        Ast::BracketAccess.new(
          expression: expression,
          from: start_position,
          to: position,
          index: index,
          file: file)
      end
    end
  end
end
