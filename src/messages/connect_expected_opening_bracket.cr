message ConnectExpectedOpeningBracket do
  title "Syntax Error"

  block do
    text "The"
    bold "list of functions and properties to expose"
    text "from a store must be enclosed by brackets"
  end

  was_looking_for "opening bracket", got, "{"

  snippet node
end
