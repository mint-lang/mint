message NextCallTypeMismatch do
  title "Type Error"

  block do
    text "A"
    bold "next call"
    text "can only set the state of a component or store to a record that"
    text "matches their state definition."
  end

  was_expecting_type expected, got

  snippet node
end
