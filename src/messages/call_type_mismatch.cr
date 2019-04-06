message CallTypeMismatch do
  title "Type Error"

  block do
    text "The type signature of the call does not match the singature"
    text "of the function."
  end

  type_with_text expected, "The type signature of the function is:"
  type_with_text got, "You tried to call it as:"

  snippet node, "You tried to call it here:"
end
