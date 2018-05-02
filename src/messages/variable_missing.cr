message VariableMissing do
  title "Type Error"

  block do
    text "I could not find a variable, function or property with the name:"
    bold name
  end

  snippet node
end
