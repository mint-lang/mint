message StringExpectedEndQuote do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "closing quote"
    code "\""
    text "of a"
    bold "string literal"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
