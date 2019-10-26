message HtmlStyleArgumentTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "#{index} argument"
    text "to a style is causing a mismatch."
  end

  type_with_text expected, "The style is expecting the #{index} argument to be:"
  type_with_text got, "Instead it is:"

  snippet node, "You tried to call it here:"
end
