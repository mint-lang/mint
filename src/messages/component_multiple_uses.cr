message ComponentMultipleUses do
  title "Type Error"

  block do
    text "You are subscribing to the provider"
    bold name
    text "multiple times."
  end

  snippet other, "A subscription is here:"
  snippet node, "An other subscription is here:"
end
