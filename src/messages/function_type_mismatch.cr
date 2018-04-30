message FunctionTypeMismatch do
  title "Type Error"

  block do
    text "A function does not match it's return type."
  end

  was_expecting_type expected, got

  snippet node
end
