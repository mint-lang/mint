message RouteExpectedExpression do
  title "Syntax Error"

  block do
    text "The body of a route must be a"
    bold "single expression."
  end

  was_looking_for "expression", got

  snippet node
end
