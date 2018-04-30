message ModuleCallExpectedFunction do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name of the function to call"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
