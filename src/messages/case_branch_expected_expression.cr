message CaseBranchExpectedExpression do
  title "Syntax Error"

  block do
    text "A case branch must have an expression."
  end

  was_looking_for "expression", got

  snippet node
end
