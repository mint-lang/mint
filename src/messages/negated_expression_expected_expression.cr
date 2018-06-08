message NegatedExpressionExpectedExpression do
  title "Syntax Error"

  block do
    text "A negated expression must have exactly one expression."
  end

  was_looking_for "expression", got

  snippet node
end
