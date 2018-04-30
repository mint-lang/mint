message HtmlElementExpectedStyle do
  title "Syntax Error"

  block do
    text "I found a"
    bold "double colon"
    code "::"
    text "which indicates that the element has a style associated with it."
  end

  was_looking_for "style", got

  snippet node
end
