message ComponentMultipleExposed do
  title "Type Error"

  block do
    text "The function or property"
    bold name
    text "from a store is exposed multiple times."
  end

  snippet other, "It is exposed here:"
  snippet node, "It is also exposed here:"
end
