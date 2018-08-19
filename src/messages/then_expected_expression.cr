message ThenExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of a"
    bold "then block"
    text "must be a single expression."
  end

  was_looking_for "expression", got

  snippet node
end
