module Mint
  class Parser
    syntax_error TupleDestructuringExpectedClosingBracket

    def tuple_destructuring
      start do |start_position|
        head = start do
          skip unless char! '{'
          value = enum_destructuring || tuple_destructuring || array_destructuring || variable
          whitespace
          char! ','
          whitespace
          value
        end

        skip unless head

        parameters = [head].concat(
          list(terminator: '}', separator: ',') do
            enum_destructuring || tuple_destructuring || array_destructuring || variable
          end.compact)

        whitespace

        char "}", TupleDestructuringExpectedClosingBracket

        Ast::TupleDestructuring.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
