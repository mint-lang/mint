module Mint
  class Parser
    INVALID_VARIABLE_NAMES =
      ["true", "false"]

    def tuple_destructuring : Ast::TupleDestructuring?
      start do |start_position|
        head = start do
          next unless char! '{'
          value = tuple_destructuring || variable(true, INVALID_VARIABLE_NAMES)
          whitespace
          next if char.in?('|', '=') # Don't parse record or record update as tuple destructuring
          char! ','
          whitespace
          value
        end

        next unless head

        parameters = [head] &+ list(terminator: '}', separator: ',') do
          tuple_destructuring || variable(true, INVALID_VARIABLE_NAMES)
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
