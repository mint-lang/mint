message ConnectExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "The"
    bold "list of functions and properties to expose"
    text "from a store must be enclosed by brackets"
  end

  block do
    text "I was looking for the"
    bold "closing bracket"
    code "}"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
