message HtmlFragmentExpectedClosingTag do
  title "Syntax Error"

  block do
    text "An"
    bold "html fragment"
    text "must have a"
    bold "closing tag."
  end

  was_looking_for "closing tag", got, "</>"

  snippet node
end
