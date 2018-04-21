message CaseBranchNotMatches do
  title "Type Error"

  block do
    text "The return type of the"
    bold "#{index}. branch"
    text "of a case expression does not match the type of the first branch."
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
