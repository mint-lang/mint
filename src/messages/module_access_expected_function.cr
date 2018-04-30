message ModuleAccessExpectedFunction do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name of the function"
    text "of a module, but found"
    code got
    text "instead."
  end

  snippet node
end
