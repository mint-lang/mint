message ParallelExpectedStatement do
  title "Syntax Error"

  block do
    text "A"
    bold "parallel expression"
    text "must have at least one statement."
  end

  block do
    text "I was looking for a"
    bold "statement"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
