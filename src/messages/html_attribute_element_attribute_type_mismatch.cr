message HtmlAttributeElementAttributeTypeMismatch do
  title "Type Error"

  block do
    text "The type of the value for the property"
    bold name
    text "of element"
    bold "tag"
    text "does not match its type"
  end

  was_expecting_type expected, got

  snippet node
end
