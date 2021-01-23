message HtmlElementExpectedClosingTag do
  title "Syntax Error"

  block do
    text "A none self closing HTML tag must have a"
    bold "closing tag."
  end

  snippet opening_tag, "I am looking for the closing tag of:"

  was_looking_for "closing tag", got

  snippet node
end
