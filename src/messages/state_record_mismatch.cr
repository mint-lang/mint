message StateRecordMismatch do
  title "Type Error"

  block do
    text "The states type does not match its type annotation."
  end
  was_expecting_type expected, got

  snippet node
end
