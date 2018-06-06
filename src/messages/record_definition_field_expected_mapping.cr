message RecordDefinitionFieldExpectedMapping do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "key"
    text "of which to decode the field from an object."
  end

  block do
    text "Instead I found"
    code got
  end

  snippet node
end
