module Mint
  class Parser
    def array_destructuring : Ast::ArrayDestructuring?
      parse do |start_position|
        next unless char! '['

        items =
          list(terminator: ']', separator: ',') { spread || destructuring }

        next if items.empty?
        whitespace

        next error :array_destructuring_expected_closing_bracket do
          expected "the closing bracket of an array destructuring", word
          snippet self
        end unless char! ']'

        Ast::ArrayDestructuring.new(
          from: start_position,
          items: items,
          to: position,
          file: file)
      end
    end
  end
end
