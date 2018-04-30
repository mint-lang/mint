message HtmlAttributeComponentPropertyTypeMismatch do
  title "Type Error"

  block do
    text "The type of the value for the property"
    bold name
    text "of the component"
    bold component
    text "does not match its definition."
  end

  was_expecting_type expected, got

  snippet node
end
