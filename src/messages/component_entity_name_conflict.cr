message ComponentEntityNameConflict do
  title "Type Error"

  block do
    text "There is already a"
    bold what
    text "with the name"
    bold name
    text "in this component."
  end

  snippet other, "It was defined here:"

  snippet node
end
