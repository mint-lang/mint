message ReturnTypeMismatch do
  title "Type Error"

  block do
    text "The type of a return call does not match the return type of the block."
  end

  was_expecting_type expected, got

  snippet node, "It is here:"
end
