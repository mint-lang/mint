module Mint
  class Parser
    syntax_error TupleLiteralExpectedClosingBracket

    def bool_tuple_literal
      start do |start_position|
        next unless char! '{'

        whitespace
        items = list(
          terminator: '}',
          separator: ','
        ) { bool_literal }
        whitespace

        next unless char! '}'

        Ast::TupleLiteral.new(
          from: start_position,
          items: items,
          to: position,
          input: data)
      end
    end

    def tuple_literal : Ast::TupleLiteral?
      start do |start_position|
        next unless char! '{'

        whitespace
        items = list(
          terminator: '}',
          separator: ','
        ) { expression }
        whitespace

        char "}", TupleLiteralExpectedClosingBracket

        Ast::TupleLiteral.new(
          from: start_position,
          to: position,
          items: items,
          input: data)
      end
    end
  end
end
