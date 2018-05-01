message RecordDefinitionFieldExpectedType do
  title "Syntax Error"

  block do
    text "All record fields must declare their type."
  end

  was_looking_for "type", got

  snippet node
end
