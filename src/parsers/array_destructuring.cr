module Mint
  class Parser
    syntax_error ArrayDestructuringExpectedClosingBracket

    def array_destructuring : Ast::ArrayDestructuring | Nil
      start do |start_position|
        head = start do
          skip unless char! '['
          value = variable || spread
          whitespace
          keyword ","
          whitespace
          value
        end

        skip unless head

        items =
          [head.as(Ast::Node)].concat(list(terminator: ']', separator: ',') do
            variable || spread
          end.compact)

        whitespace

        char "]", ArrayDestructuringExpectedClosingBracket

        Ast::ArrayDestructuring.new(
          from: start_position,
          items: items,
          to: position,
          input: data)
      end
    end
  end
end
