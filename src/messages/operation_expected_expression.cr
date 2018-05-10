message OperationExpectedExpression do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "right side expression"
    text "of an"
    bold "operation"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
