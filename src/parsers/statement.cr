module Mint
  class Parser
    def statement : Ast::Statement | Nil
      start do |start_position|
        name = start do
          value = variable
          whitespace
          skip unless keyword "="
          whitespace
          value
        end

        body = expression

        skip unless body

        Ast::Statement.new(
          expression: body.as(Ast::Expression),
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
