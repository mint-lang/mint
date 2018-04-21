message CaseBranchNotMatchCondition do
  title "Type Error"

  block do
    text "A branch of a case expression does not match the type of the condition."
  end

  block do
    text "I was expecting:"
  end

  type expected

  block do
    text "Instead it is:"
  end

  type got

  snippet node
end
