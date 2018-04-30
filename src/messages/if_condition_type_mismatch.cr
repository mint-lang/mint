message IfConditionTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "condition of an if expression"
    text "does not evaluate to a boolean."
  end

  was_expecting_type expected, got

  snippet node
end
