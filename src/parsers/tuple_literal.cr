module Mint
  class Parser
    def tuple_literal : Ast::TupleLiteral?
      start do |start_position|
        next unless char! '{'

        whitespace
        items = list(
          terminator: '}',
          separator: ','
        ) { expression }
        whitespace

        next unless char! '}'

        Ast::TupleLiteral.new(
          from: start_position,
          to: position,
          items: items,
          input: data)
      end
    end
  end
end
