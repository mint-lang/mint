message HtmlElementExpectedReference do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "identifier"
    text "of the element after the"
    code "as"
    text "keyword but found"
    code got
    text "instead."
  end

  snippet node
end
