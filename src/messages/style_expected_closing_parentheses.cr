message StyleExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "The"
    bold "arguments"
    text "of a"
    bold "style"
    text "must be enclosed by parenthesis."
  end

  was_looking_for "closing parenthesis", got, ")"

  snippet node
end
