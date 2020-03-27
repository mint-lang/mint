message RecordConstructorArgumentTypeMismatch do
  title "Type Error"

  block do
    text "The supplied values type does not match the type"
    text "of the field."
  end

  type_with_text expected, "The type of the field is:"
  type_with_text got, "You tried to supply it with:"

  snippet node
end
