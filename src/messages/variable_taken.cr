message VariableTaken do
  title "Type Error"

  block do
    text "There is already a variable with the same name in this scope:"
    bold name
  end

  snippet node, "You are trying to define the variable here:"
  snippet existing, "But it is already defined here:"
end
