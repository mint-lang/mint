message ArrayExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I was looking for the closing bracket "
    code "]"
    text " of the array but found "
    code got
    text " instead."
  end

  snippet node
end
