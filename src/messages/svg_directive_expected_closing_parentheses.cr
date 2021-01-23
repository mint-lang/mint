message SvgDirectiveExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "The"
    bold "path"
    text "of an"
    bold "svg directive"
    text "must be enclosed by parenthesis."
  end

  was_looking_for "closing parenthesis", got, ")"

  snippet node
end
