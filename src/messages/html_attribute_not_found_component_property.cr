message HtmlAttributeNotFoundComponentProperty do
  title "Type Error"

  block do
    text "I was looking for the property"
    bold name
    text "on the"
    bold component
    text "component but could not find it."
  end

  list properties, "Maybe you want one of its properties:"

  snippet node
end
