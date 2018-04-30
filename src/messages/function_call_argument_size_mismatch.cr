message FunctionCallArgumentSizeMismatch do
  title "Type Error"

  block do
    text "You tried to call the function"
    bold name
    text "with more or less arguments."
  end

  type_with_text expected, "The type signature of the function is:"
  type_with_text got, "You tried to call it as:"

  snippet node, "You tried to call it here:"
  snippet function, "The called function is defined here:"
end
