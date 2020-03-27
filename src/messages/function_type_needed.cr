message FunctionTypeNeeded do
  title "Type Error"

  block do
    text "Type"
    bold "return type"
    text "of a"
    bold "function"
    text "needs to be defined if the function is called recursively."
  end

  snippet node, "The function in question is:"
end
