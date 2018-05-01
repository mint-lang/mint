message ParenthesizedExpressionExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "closing parentheses"
    code ")"
    text "of a"
    bold "parenthesized expression"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
