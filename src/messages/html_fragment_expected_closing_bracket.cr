message HtmlFragmentExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I was looking for closing bracket"
    code ">"
    text "of a html fragment but got"
    code got
    text "instead."
  end

  snippet node
end
