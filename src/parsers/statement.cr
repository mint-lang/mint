module Mint
  class Parser
    def statement : Ast::Statement?
      start do |start_position|
        target = start do
          value = variable(track: false) || tuple_destructuring
          whitespace

          next unless keyword "="
          next if char == '=' # Don't parse == operation as statement.

          whitespace
          value
        end

        whitespace
        await = keyword "await"

        whitespace
        body = expression

        next unless body

        self << Ast::Statement.new(
          from: start_position,
          expression: body,
          target: target,
          await: await,
          to: position,
          input: data)
      end
    end
  end
end
