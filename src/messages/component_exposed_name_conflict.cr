message ComponentExposedNameConflict do
  title "Type Error"

  block do
    text "You cannot expose"
    bold name
    text "from the store because the name is already taken."
  end

  snippet other, message: "The entity with the same name is here:"

  snippet node
end
