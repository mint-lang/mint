message CatchExpectedExpression do
  title "Syntax Error"

  block do
    text "A catch must have exactly one expression."
  end

  block do
    text "I was looking for that"
    bold "expression"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
