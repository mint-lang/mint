message RecordUpdateTypeMismatch do
  title "Type Error"

  block do
    text "One of the updated fields do not match its type."
  end

  was_expecting_type expected, got

  snippet node, "The update is here:"
  snippet target_node, "The target is defined here:"
end
