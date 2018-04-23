message ComponentMultipleConnects do
  title "Type Error"

  block do
    text "The component is connected to the store"
    bold name
    text "multiple times."
  end

  snippet other, "It is connected here:"
  snippet node, "It is also connected here:"
end
