module Mint
  class Parser
    syntax_error ArrayExpectedClosingBracket

    def array : Ast::ArrayLiteral | Nil
      start do |start_position|
        skip unless char! '['

        whitespace

        items = list(
          terminator: ']', separator: ','
        ) {
          expression.as(Ast::Expression | Nil)
        }.compact

        whitespace

        char "]", ArrayExpectedClosingBracket

        Ast::ArrayLiteral.new(
          from: start_position,
          items: items,
          to: position,
          input: data)
      end
    end
  end
end
