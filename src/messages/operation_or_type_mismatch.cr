message OperationOrTypeMismatch do
  title "Type Error"

  block do
    text "The type of the default value does not match the type of the"
    text "parameter of the maybe."
  end

  was_expecting_type expected, got

  snippet node
end
