module Mint
  class Parser
    def statement : Ast::Statement | Nil
      start do |start_position|
        variables = start do
          value = list(terminator: nil, separator: ',') { variable }.compact
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
          variables: variables,
          to: position,
          input: data)
      end
    end
  end
end
