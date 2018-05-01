message RecordUpdateExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "The"
    bold "fields of a record update"
    text "must be enclosed by brackets."
  end

  was_looking_for "closing bracket", got, "}"

  snippet node
end
