message CaseBranchNotArray do
  title "Type Error"

  block do
    text "This branch of a case expression expected to match an array."
  end

  block do
    text "I was expecting an"
    code "Array"
    text "but instead it is:"
  end

  type got

  snippet node
end
