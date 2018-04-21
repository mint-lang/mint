message CaseExpectedCondition do
  title "Syntax Error"

  block do
    text "I was looking for the "
    bold "condition "
    text "of a "
    bold "case expression "
    text "but found "
    code got
    text " instead."
  end

  snippet node
end
