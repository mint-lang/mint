message RouteNotVoid do
  title "Type Error"

  block do
    text "A route is considered a side effect, and bacause of that"
    text "it must return"
    bold "Void"
  end

  was_expecting_type TypeChecker::VOID, got

  snippet node
end
