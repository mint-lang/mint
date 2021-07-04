message FunctionTypeMismatch do
  title "Type Error"

  block do
    text "The return type of a function does not match its type definition."
  end

  was_expecting_type expected, got

  snippet node
end
