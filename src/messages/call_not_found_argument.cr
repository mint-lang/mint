message CallNotFoundArgument do
  title "Type Error"

  block do
    text "I was looking for the name argument:"
    bold name
    text "but it's not there."
  end

  snippet node, "The call is here:"
end
