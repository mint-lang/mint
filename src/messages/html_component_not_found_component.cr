message HtmlComponentNotFoundComponent do
  title "Type Error"

  block do
    text "I was looking for a component named"
    bold name
    text "but I could not find it."
  end

  snippet node
end
