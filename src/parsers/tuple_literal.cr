module Mint
  class Parser
    syntax_error TupleLiteralExpectedClosingBracket

    def tuple_literal : Ast::TupleLiteral | Nil
      start do |start_position|
        skip unless char! '{'

        whitespace
        head = expression
        whitespace

        skip unless head

        items = [] of Ast::Expression

        case char
        when ','
          step
          whitespace

          items = list(
            terminator: '}', separator: ','
          ) {
            expression.as(Ast::Expression | Nil)
          }.compact

          whitespace

          char "}", TupleLiteralExpectedClosingBracket
        when '}'
          step
        else
          skip
        end

        items.unshift(head)

        Ast::TupleLiteral.new(
          from: start_position,
          to: position,
          items: items,
          input: data)
      end
    end
  end
end
