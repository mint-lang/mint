message RecordFieldsConflict do
  title "Type Error"

  block do
    text "There is already a"
    bold "record"
    text "with the same structure."
  end

  snippet node, "One of them is here:"
  snippet other, "The other is here:"
end
