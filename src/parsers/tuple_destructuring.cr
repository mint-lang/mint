module Mint
  class Parser
    syntax_error TupleDestructuringExpectedClosingBracket

    def tuple_destructuring : Ast::TupleDestructuring?
      start do |start_position|
        head = start do
          next unless char! '{'
          value = tuple_destructuring || variable
          whitespace
          char! ','
          whitespace
          value
        end

        next unless head

        parameters = [head] &+ list(terminator: '}', separator: ',') do
          tuple_destructuring || variable
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
  end
end
