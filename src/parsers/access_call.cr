module Mint
  class Parser
    syntax_error AccessCallExpectedClosingParentheses

    def access_call : Ast::AccessCall | Nil
      start do |start_position|
        access = self.access

        skip unless access
        skip unless char! '('

        whitespace
        arguments = list(
          terminator: ')',
          separator: ','
        ) { expression.as(Ast::Expression | Nil) }.compact
        whitespace

        char ')', AccessCallExpectedClosingParentheses

        Ast::AccessCall.new(
          arguments: arguments,
          from: start_position,
          access: access,
          piped: false,
          to: position,
          input: data)
      end
    end
  end
end
