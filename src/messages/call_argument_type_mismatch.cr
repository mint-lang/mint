message CallArgumentTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "#{index} argument"
    text "to a function is causing a mismatch."
  end

  type_with_text expected, "The function is expecting the #{index} argument to be:"
  type_with_text got, "Instead it is:"

  snippet node, "You tried to call it here:"
end
