message WithExpectedExpression do
  title "Syntax Error"

  block do
    text "The body of a with expression must be a single"
    bold "expression."
  end

  was_looking_for "expression", got

  snippet node
end
