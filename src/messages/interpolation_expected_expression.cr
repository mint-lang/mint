message InterpolationExpectedExpression do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "expression"
    text "of a CSS interpolation but found"
    code got
    text "instead."
  end

  snippet node
end
