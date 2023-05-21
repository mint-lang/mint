message StatementReturnRequired do
  title "Type Error"

  block do
    text "This"
    bold "statement"
    text "needs a "
    bold "return call"
    text "because the destructuring is not exhaustive."
  end

  snippet node
end
