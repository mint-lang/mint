module Mint
  class Parser
    def statement(parent : Ast::Statement::Parent) : Ast::Statement?
      start do |start_position|
        target = start do
          value = variable(track: false) || tuple_destructuring
          whitespace
          next unless keyword "="
          next if char == '=' # Don't parse == operation as statement.
          whitespace
          value
        end

        body = expression

        next unless body

        self << Ast::Statement.new(
          expression: body,
          from: start_position,
          target: target,
          parent: parent,
          to: position,
          input: data)
      end
    end
  end
end
