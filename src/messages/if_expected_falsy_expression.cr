message IfExpectedFalsyExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "body of an else branch"
    text "of an if expression must be a single expression."
  end

  was_looking_for "expression", got

  snippet node
end
