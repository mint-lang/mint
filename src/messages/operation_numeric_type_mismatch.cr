message OperationNumericTypeMismatch do
  title "Type Error"

  block do
    text "The type of the"
    bold side
    text "operand does not match the type of the operation:"
    bold operator
  end

  was_expecting_type TypeChecker::NUMBER, value

  snippet node
end
