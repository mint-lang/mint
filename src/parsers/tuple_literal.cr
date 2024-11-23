module Mint
  class Parser
    def tuple_literal : Ast::TupleLiteral?
      parse do |start_position|
        next unless char! '{'

        whitespace
        next unless head = commented_expression

        whitespace
        next unless char! ','

        items =
          list(terminator: '}', separator: ',') { commented_expression }

        whitespace
        next unless char! '}'

        items.unshift(head)

        Ast::TupleLiteral.new(
          from: start_position,
          to: position,
          items: items,
          file: file)
      end
    end
  end
end
