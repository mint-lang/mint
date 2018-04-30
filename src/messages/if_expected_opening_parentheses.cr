message IfExpectedOpeningParentheses do
  title "Syntax Error"

  block do
    text "The"
    bold "condition"
    text "of an"
    bold "if expression"
    text "must be enclosed by parenthesis."
  end

  was_looking_for "opening parenthesis", got, "("

  snippet node
end
