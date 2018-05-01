message RoutesExpectedRoute do
  title "Syntax Error"

  block do
    text "The body of a"
    bold "routes block must contain at least"
    bold "one route."
  end

  was_looking_for "route", got

  snippet node
end
