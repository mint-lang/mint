message EnumDestructuringExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "closing parenthesis"
    code ")"
    text "of the destructuring of an"
    bold "enum"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
