message ArrayDestructuringExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I was looking for the closing bracket"
    code "]"
    text "after items of the array destructuring, but found"
    code got
    text "instead."
  end

  snippet node
end
