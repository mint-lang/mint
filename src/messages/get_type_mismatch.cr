message GetTypeMismatch do
  title "Type Error"

  block do
    text "The return type of a get does not match it's type definition."
  end

  was_expecting_type expected, got

  snippet node
end
