message OperationTypeMismatch do
  title "Type Error"

  block do
    text "The type of the right operand does not match the type of the"
    text "left operand."
  end

  was_expecting_type left, right

  snippet node
end
