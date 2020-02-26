module Mint
  class Ast
    class ArrayDestructuring < Node
      getter items

      def initialize(@items : Array(Node),
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end

    class Spread < Node
      getter variable

      def initialize(@variable : Variable,
                     @input : Data,
                     @from : Int32,
                     @to : Int32)
      end
    end
  end

  class Parser
    # syntax_error SpreadExpectedVariable

    def spread
      start do |start_position|
        skip unless keyword "..."

        variable = variable! SyntaxError

        Ast::Spread.new(
          from: start_position,
          variable: variable,
          to: position,
          input: data)
      end
    end

    syntax_error ArrayDestructuringExpectedClosingBracket

    def array_destructuring : Ast::ArrayDestructuring | Nil
      start do |start_position|
        head = start do
          skip unless char! '['
          value = variable
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
