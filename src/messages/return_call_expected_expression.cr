message ReturnCallExpectedExpression do
  title "Syntax Error"

  block do
    text "I was looking for an"
    bold "expression"
    text "for a"
    bold "return call"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
