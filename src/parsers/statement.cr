module Mint
  class Parser
    def statement(allow_enum_destructuring = false) : Ast::Statement?
      start do |start_position|
        target = start do
          next unless keyword "let"
          whitespace

          value = variable(track: false) || tuple_destructuring
          value = enum_destructuring if value.nil? && allow_enum_destructuring

          whitespace

          next unless char! '='
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
