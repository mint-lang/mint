message OperationPlusTypeMismatch do
  title "Type Error"

  block do
    text "The type of the"
    bold side
    text "operand does not match the type of the operation:"
    bold "+"
  end

  block do
    text "I was expecting one of these types:"
  end

  pre "Number, String"

  type_with_text value, "Instead it is:"

  snippet node
end
