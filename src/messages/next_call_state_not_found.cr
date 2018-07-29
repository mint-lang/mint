message NextCallStateNotFound do
  title "Type Error"

  block do
    text "I was looking for a state named"
    bold name
    text "but could not find it."
  end

  snippet node
end
