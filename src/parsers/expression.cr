class Parser
  def expression!(error : SyntaxError.class) : Ast::Expression
    raise error unless exp = expression
    exp
  end

  def expression : Ast::Expression | Nil
    return unless left = basic_expression

    if operator = self.operator
      rollup_pipe operation(left, operator)
    else
      left
    end
  end
end
