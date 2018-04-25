message CssDefinitionTypeMismatch do
  title "Type Error"

  block do
    text "The type of the value for the CSS property"
    bold name
    text "is invalid."
  end

  block do
    text "I was expecting one of these types:"
  end

  pre "String, Number"

  type_with_text got, "Instead it is:"

  snippet node
end
