message StateNotFoundRecord do
  title "Type Error"

  block do
    text "I was looking for the"
    bold "record of the state"
    text "of a component but could not find it."
  end

  type_with_text record, "I was expecting a record for this structure:"

  snippet node
end
