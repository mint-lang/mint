message SvgDirectiveExpectedOpeningParentheses do
  title "Syntax Error"

  block do
    text "I was looking for the "
    bold "opening parenthesis "
    code "("
    text "of an"
    bold "svg directive "
    text "but found "
    code got
    text " instead."
  end

  snippet node
end
