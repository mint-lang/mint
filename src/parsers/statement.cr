module Mint
  class Parser
    def statement(parent : Ast::Statement::Parent, require_name : Bool = false) : Ast::Statement?
      start do |start_position|
        await = keyword "await"
        whitespace if await

        target = start do
          value = variable(track: false) || tuple_destructuring
          whitespace

          next unless keyword "="
          next if char == '=' # Don't parse == operation as statement.

          whitespace
          value
        end

        next if require_name && !target
        body = expression

        next unless body

        self << Ast::Statement.new(
          from: start_position,
          expression: body,
          target: target,
          parent: parent,
          await: await,
          to: position,
          input: data)
      end
    end
  end
end
