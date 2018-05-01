message TryExpectedStatement do
  title "Syntax Error"

  block do
    text "I was looking for at least one"
    bold "statement"
    text "for a try expression but found"
    code got
    text "instead."
  end

  snippet node
end
