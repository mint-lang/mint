module Mint
  class Parser
    syntax_error WhereExpectedExpression
    syntax_error WhereExpectedEqualSign

    def where_statement : Ast::WhereStatement | Nil
      start do |start_position|
        skip unless name = variable
        whitespace

        char '=', WhereExpectedEqualSign
        whitespace

        expression = expression! WhereExpectedExpression

        Ast::WhereStatement.new(
          expression: expression,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
