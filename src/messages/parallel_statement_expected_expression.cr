message ParallelStatementExpectedExpression do
  title "Syntax Error"

  block do
    text "A"
    bold "statement"
    text "in a"
    bold "parallel expression"
    text "must have an expression."
  end

  was_looking_for "expression", got

  snippet node
end
