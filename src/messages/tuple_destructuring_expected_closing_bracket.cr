message TupleDestructuringExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I was looking for the closing bracket"
    code "}"
    text "after the last item in a tuple destructuring, but found"
    code got
    text "instead."
  end

  snippet node
end
