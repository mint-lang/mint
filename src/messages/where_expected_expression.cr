message WhereExpectedExpression do
  title "Syntax Error"

  block do
    text "A where statement must have an"
    bold "expression"
    text "after the equal sign."
  end

  was_looking_for "expression", got

  snippet node
end
