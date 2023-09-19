module Mint
  class Parser
    def array_access(expression : Ast::Node) : Ast::ArrayAccess?
      parse do |start_position|
        next unless char! '['
        whitespace

        next error :array_access_expected_index do
          expected "the index of an array access", word
          snippet self
        end unless index = self.expression
        whitespace

        next error :array_access_expected_closing_bracket do
          expected "the closing bracket of an array access", word
          snippet self
        end unless char! ']'

        Ast::ArrayAccess.new(
          expression: expression,
          from: start_position,
          to: position,
          index: index,
          file: file)
      end
    end
  end
end
