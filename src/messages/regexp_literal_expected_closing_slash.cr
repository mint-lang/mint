message RegexpLiteralExpectedClosingSlash do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "end slash"
    code "/"
    text "of a"
    bold "regexp literal"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
