message GetExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of a"
    bold "get"
    text "must be a single expression."
  end

  was_looking_for "expression", got

  snippet node
end
