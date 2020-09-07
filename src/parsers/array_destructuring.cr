module Mint
  class Parser
    syntax_error ArrayDestructuringExpectedClosingBracket

    def array_destructuring : Ast::ArrayDestructuring?
      start do |start_position|
        head = start do
          skip unless char! '['
          value = enum_destructuring || tuple_destructuring || array_destructuring || variable || spread
          whitespace
          keyword ","
          whitespace
          value
        end

        skip unless head

        items =
          [head.as(Ast::ArrayDestructuring::ArrayDestructuringItem)].concat(list(terminator: ']', separator: ',') do
            value = enum_destructuring || tuple_destructuring || array_destructuring || variable || spread
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

    def parse_destructuring_item
    end
  end
end
