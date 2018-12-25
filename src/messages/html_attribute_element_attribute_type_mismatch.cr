message HtmlAttributeElementAttributeTypeMismatch do
  title "Type Error"

  block do
    text "The type of the value for the property"
    bold name
    text "of element"
    bold "tag"
    text "does not match its type."
  end

  block do
    text "I was expecting one of the following types:"
  end

  pre expected

  type_with_text got, "Instead it is:"

  snippet node
end
