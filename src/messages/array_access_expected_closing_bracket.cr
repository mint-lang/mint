message ArrayAccessExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I was looking for the closing bracket"
    code "]"
    text "after the array index, but found"
    code got
    text "instead."
  end

  snippet node
end
