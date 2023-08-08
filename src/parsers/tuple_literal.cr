module Mint
  class Parser
    def tuple_literal : Ast::TupleLiteral?
      parse do |start_position|
        # TODO: Remove this branch in 0.21.0 when deprecation ends.
        if char! '{'
          whitespace

          items = list(terminator: '}', separator: ',') { expression }

          whitespace
          next unless char! '}'
        elsif word!("#(")
          whitespace
          items = list(terminator: '}', separator: ',') { expression }
          whitespace

          next error :tuple_literal_expected_closing_parenthesis do
            expected "the closing parenthesis of a tuple", word
            snippet self
          end unless char! ')'
        else
          next
        end

        Ast::TupleLiteral.new(
          from: start_position,
          to: position,
          items: items,
          file: file)
      end
    end
  end
end
