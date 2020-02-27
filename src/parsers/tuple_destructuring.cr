module Mint
  class Parser
    def tuple_destructuring
      start do |start_position|
        head = start do
          skip unless char! '{'
          value = variable
          whitespace
          char! ','
          whitespace
          value
        end

        skip unless head

        parameters = [head].concat(
          list(terminator: '}', separator: ',') { variable }.compact)

        whitespace

        char "}", SyntaxError

        Ast::TupleDestructuring.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
