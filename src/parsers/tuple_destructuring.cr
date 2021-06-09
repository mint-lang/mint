module Mint
  class Parser
    syntax_error TupleDestructuringExpectedClosingBracket

    def tuple_destructuring
      start do |start_position|
        head = start do
          next unless char! '{'
          value = variable
          whitespace
          char! ','
          whitespace
          value
        end

        next unless head

        parameters = [] of Ast::Node
        parameters << head
        parameters.concat(list(terminator: '}', separator: ',') { variable })

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
