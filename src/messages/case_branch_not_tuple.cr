message CaseBranchNotTuple do
  title "Type Error"

  block do
    text "This branch of a case expression expected to match a tuple."
  end

  block do
    text "I was expecting a"
    code "Tuple"
    text "but instead it is:"
  end

  type got

  snippet node
end
