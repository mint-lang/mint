message TryCatchesNothing do
  title "Type Error"

  block do
    text "There are no statements that can result (as an error) in this type:"
  end

  type got

  snippet node, "There is a catch for this type, which now can be removed:"
end
