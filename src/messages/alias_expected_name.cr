message AliasExpectedName do
  title "Syntax Error"

  block do
    text "I was looking for an"
    bold "uppercase letter for the type alias"
    text "but found"
    char got
    text "instead."
  end

  snippet node
end
