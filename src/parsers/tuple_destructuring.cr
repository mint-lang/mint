module Mint
  class Parser
    def tuple_destructuring : Ast::TupleDestructuring?
      start do |start_position|
        head = start do
          next unless char! '{'
          value = destructuring
          whitespace
          next if char.in?('|', '=') # Don't parse record or record update as tuple destructuring
          char! ','
          whitespace
          value
        end

        next unless head

        parameters = [head] &+ list(terminator: '}', separator: ',') do
          destructuring
        end

        whitespace

        next unless char! '}'

        Ast::TupleDestructuring.new(
          parameters: parameters,
          from: start_position,
          to: position,
          input: data)
      end
    end
  end
end
