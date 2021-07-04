message GetTypeMismatch do
  title "Type Error"

  block do
    text "The return type of a get does not match its type definition."
  end

  was_expecting_type expected, got

  snippet node
end
