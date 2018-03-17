class Parser
  syntax_error WhereExpectedOpeningBracket
  syntax_error WhereExpectedClosingBracket
  syntax_error WhereExpectedExpression
  syntax_error WhereExpectedEqualSign
  syntax_error WhereExpectedWhere

  def where : Array(Ast::Where)
    return [] of Ast::Where unless keyword "where"

    block(
      opening_bracket: WhereExpectedOpeningBracket,
      closing_bracket: WhereExpectedClosingBracket
    ) do
      wheres = many { where_statement }.compact
      raise WhereExpectedWhere if wheres.empty?
      wheres
    end
  end

  def where_statement : Ast::Where | Nil
    start do |start_position|
      skip unless name = variable

      whitespace
      char '=', WhereExpectedEqualSign
      whitespace
      expression = expression! WhereExpectedExpression

      Ast::Where.new(
        expression: expression,
        from: start_position,
        to: position,
        input: data,
        name: name)
    end
  end
end
