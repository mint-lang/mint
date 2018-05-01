message ModuleExpectedName do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name of a module"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
