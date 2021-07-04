message InlineFunctionTypeMismatch do
  title "Type Error"

  block do
    text "The return type of an anonymous function does not match its type definition."
  end

  was_expecting_type expected, got

  snippet node
end
