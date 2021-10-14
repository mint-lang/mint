module Mint
  class Parser
    syntax_error CallExpectedClosingParentheses

    def call(lhs : Ast::Expression) : Ast::Expression
      start do |start_position|
        next unless char! '('

        whitespace
        arguments = list(
          terminator: ')',
          separator: ','
        ) { expression.as(Ast::Expression?) }
        whitespace

        char ')', CallExpectedClosingParentheses

        node = self << Ast::Call.new(
          partially_applied: false,
          from: start_position,
          arguments: arguments,
          expression: lhs,
          to: position,
          input: data)

        array_access_or_call(node)
      end || lhs
    end
  end
end
