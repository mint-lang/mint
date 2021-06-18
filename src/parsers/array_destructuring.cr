module Mint
  class Parser
    syntax_error ArrayDestructuringExpectedClosingBracket

    def array_destructuring : Ast::ArrayDestructuring?
      start do |start_position|
        head = start do
          next unless char! '['
          value = variable || spread
          whitespace
          char! ','
          whitespace
          value
        end

        next unless head

        items =
          [head.as(Ast::Node)] &+ list(terminator: ']', separator: ',') do
            variable || spread
          end

        whitespace

        char ']', ArrayDestructuringExpectedClosingBracket

        Ast::ArrayDestructuring.new(
          from: start_position,
          items: items,
          to: position,
          input: data)
      end
    end
  end
end
