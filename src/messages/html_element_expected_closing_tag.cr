message HtmlElementExpectedClosingTag do
  title "Syntax Error"

  block do
    text "A none self closing HTML tag must ha have a"
    bold "closing tag."
  end

  was_looking_for "closing tag", got

  snippet node
end
