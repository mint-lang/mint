message RecordUpdateExpectedFields do
  title "Syntax Error"

  block do
    text "I was expecting"
    bold "at least one field to update"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
