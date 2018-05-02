message WithExpectedModule do
  title "Syntax Error"

  block do
    text "I was looking for"
    bold "name of a module"
    text "for a with expression but found"
    code got
    text "instead."
  end

  snippet node
end
