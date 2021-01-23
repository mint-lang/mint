message RecordNotFoundMatchingRecordDefinition do
  title "Type Error"

  block do
    text "I could not find a record that matches this structure:"
  end

  type structure

  snippet node, "It was used here:"
end
