message UseConditionMismatch do
  title "Type Error"

  block do
    text "The expression of the"
    bold "where condition"
    text "must evaluate to a boolean value."
  end

  was_expecting_type TypeChecker::BOOL, got

  snippet node
end
