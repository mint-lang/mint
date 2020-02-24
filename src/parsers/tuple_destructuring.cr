module Mint
  class Parser
    def tuple_destructuring
      start do |start_position|
        head = start do
          value = variable
          whitespace
          skip unless keyword ","
          whitespace
          value
        end

        skip unless head

        parameters = [head].concat(
          list(terminator: nil, separator: ',') { variable }.compact)

        Ast::TupleDestructuring.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
