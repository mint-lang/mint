message ForConditionTypeMismatch do
  title "Type Error"

  block do
    text "The condition of a for expression has an invalid type."
  end

  was_expecting_type expected, got

  snippet node
end
