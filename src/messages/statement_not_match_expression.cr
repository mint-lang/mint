message StatementNotMatchExpression do
  title "Type Error"

  block do
    text "The target of a statement does not match the type of the expression."
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
