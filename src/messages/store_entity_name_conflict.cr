message StoreEntityNameConflict do
  title "Type Error"

  block do
    text "There is already a"
    bold what
    text "with the name:"
    bold name
    text "in this store."
  end

  snippet node, "You are trying to define something with the same name here:"
  snippet other, "The #{what} is defined here:"
end
