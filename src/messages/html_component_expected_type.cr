message HtmlComponentExpectedType do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "component identifier"
    text "of a component tag but found"
    code got
    text "instead."
  end

  block do
    text "A component identifier must start with an uppercase letter"
    text "and only contain numbers, upper- and lowercase characters."
  end

  snippet node
end
