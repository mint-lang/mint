module Mint
  class Parser
    syntax_error WhereExpectedExpression
    syntax_error WhereExpectedEqualSign

    def where_statement : Ast::WhereStatement | Nil
      start do |start_position|
        variables = list(terminator: nil, separator: ',') { variable }.compact
        skip if variables.empty?
        whitespace

        char '=', WhereExpectedEqualSign
        whitespace

        expression = expression! WhereExpectedExpression

        Ast::WhereStatement.new(
          expression: expression,
          from: start_position,
          variables: variables,
          to: position,
          input: data)
      end
    end
  end
end
