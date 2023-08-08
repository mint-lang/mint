module Mint
  class Parser
    def array_destructuring : Ast::ArrayDestructuring?
      start do |start_position|
        head = start do
          next unless char! '['
          value = spread || destructuring
          whitespace
          char! ','
          whitespace
          value
        end

        next unless head

        items =
          [head.as(Ast::Node)] &+ list(terminator: ']', separator: ',') do
            spread || destructuring
          end

        whitespace
        next error :array_destructuring_expected_closing_bracket do
          expected "the closing bracket of the array destructuring", word
          snippet self
        end unless char! ']'

        Ast::ArrayDestructuring.new(
          from: start_position,
          items: items,
          to: position,
          input: data)
      end
    end
  end
end
