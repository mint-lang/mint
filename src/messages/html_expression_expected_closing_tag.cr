message HtmlExpressionExpectedClosingTag do
  title "Syntax Error"

  block do
    text "A HTML expression needs to be closed with a closing tag."
  end

  was_looking_for "closing tag", got, "}>"

  snippet node
end
