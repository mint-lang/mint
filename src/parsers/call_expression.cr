module Mint
  class Parser
    def call_expression : Ast::CallExpression?
      start do |start_position|
        name =
          start do
            next unless key = variable
            whitespace

            next unless char! ':'
            whitespace

            key
          end

        return unless expression = self.expression

        Ast::CallExpression.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
