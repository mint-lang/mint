message FunctionCallNotAFunction do
  title "Type Error"

  block do
    text "You tried to call"
    bold name
    text "as a function which is not."
  end

  snippet function, "The type of the entity is this:"
  snippet node, "You tried to call it here:"
end
