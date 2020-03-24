message RecordConstructorArgumentSizeMismatch do
  title "Type Error"

  block do
    text "The record you tried to create has"
    bold size
    text "fields, while you tried to create it with"
    bold argument_size
  end

  type record

  snippet node, "You tried to create it here:"
end
