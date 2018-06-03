message NegatedExpressionNotBool do
  title "Type Error"

  block do
    text "A negated expressions expression must evaluate to bool."
  end

  was_expecting_type expected, got

  snippet node
end
