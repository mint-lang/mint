message TestExpectedExpression do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "expression"
    text "of a"
    bold "test"
    text "but found"
    code got
    text "instead."
  end

  block do
    text "The expression of a test must evaluate to a boolean."
  end

  snippet node
end
