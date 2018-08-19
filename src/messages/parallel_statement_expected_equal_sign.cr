message ParallelStatementExpectedEqualSign do
  title "Syntax Error"

  block do
    text "The"
    bold "name"
    text "of a statement and its"
    bold "expression"
    text "must be separated by an"
    bold "equal sign"
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
