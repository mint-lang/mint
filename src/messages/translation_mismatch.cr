message TranslationMismatch do
  title "Type Error"

  block do
    text "The type of the key"
    bold value
    text "in the language:"
    bold language
    text "does not match the type in another language."
  end

  was_expecting_type expected, got

  snippet node
end
