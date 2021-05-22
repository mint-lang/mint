module Mint
  class Parser
    syntax_error TupleDestructuringExpectedClosingBracket

    def tuple_destructuring
      start do |start_position|
        head = start do
          next unless char! '{'
          value = tuple_destructuring_value
          whitespace
          char! ','
          whitespace
          value
        end

        next unless head

        parameters =
          [head.as(Ast::Node)] &+ list(terminator: '}', separator: ',') do
            tuple_destructuring_value
          end

        whitespace

        char '}', TupleDestructuringExpectedClosingBracket

        Ast::TupleDestructuring.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data)
      end
    end

    private def tuple_destructuring_value : Ast::Node?
      tuple_destructuring.as(Ast::Node?) || variable.as(Ast::Node?)
    end
  end
end
