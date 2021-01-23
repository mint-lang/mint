message OperationOrNotMaybe do
  title "Type Error"

  block do
    text "For the"
    bold "or"
    text "operation the"
    bold "left operand"
    text "is invalid."
  end

  was_expecting_type expected, got

  snippet node
end
