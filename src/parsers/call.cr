module Mint
  class Parser
    syntax_error CallExpectedClosingParentheses

    def call(lhs : Ast::Expression, safe : Bool = false) : Ast::Expression
      start do |start_position|
        if safe
          keyword! "&(", SkipError
        else
          char '(', SkipError
        end

        whitespace
        arguments = list(
          terminator: ')',
          separator: ','
        ) { expression.as(Ast::Expression?) }.compact
        whitespace

        char ')', CallExpectedClosingParentheses

        node = self << Ast::Call.new(
          partially_applied: false,
          from: start_position,
          arguments: arguments,
          expression: lhs,
          to: position,
          input: data,
          safe: safe
        )

        array_access_or_call(node)
      end || lhs
    end
  end
end
