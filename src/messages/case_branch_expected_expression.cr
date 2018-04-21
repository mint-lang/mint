message CaseBranchExpectedExpression do
  title "Syntax Error"

  block do
    text "I was looking for the "
    bold "expression"
    text " of a case branch but found "
    code got
    text " instead."
  end

  snippet node
end
