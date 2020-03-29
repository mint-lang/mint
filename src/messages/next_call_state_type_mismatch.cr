message NextCallStateTypeMismatch do
  title "Type Error"

  block do
    text "The type of the state"
    bold name
    text "does not match of its definition in a"
    bold "next call."
  end

  was_expecting_type expected, got

  snippet node
end
