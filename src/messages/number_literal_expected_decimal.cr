message NumberLiteralExpectedDecimal do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "decimal part"
    text "of a"
    bold "number"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
