message TypeExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "The"
    bold "type parameters"
    text "must be enclosed by parenthesis."
  end

  was_looking_for "closing parenthesis", got, ")"

  snippet node
end
