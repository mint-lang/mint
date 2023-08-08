module Mint
  class Parser
    def tuple_destructuring : Ast::TupleDestructuring?
      parse do |start_position|
        # TODO: Remove this branch in 0.21.0 when deprecation ends.
        if char! '{'
          whitespace

          items = list(terminator: '}', separator: ',') { destructuring }

          whitespace
          next unless char! '}'
        elsif word!("#(")
          whitespace
          items = list(terminator: '}', separator: ',') { destructuring }
          whitespace

          next error :tuple_destructuring_expected_closing_parenthesis do
            expected "the closing parenthesis of a tuple destructuring", word
            snippet self
          end unless char! ')'
        else
          next
        end

        Ast::TupleDestructuring.new(
          from: start_position,
          to: position,
          items: items,
          file: file)
      end
    end
  end
end
