message CaseExpectedBranches do
  title "Syntax Error"

  block do
    text "I was looking for"
    bold "a branch"
    text "of a"
    bold "case expression"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
