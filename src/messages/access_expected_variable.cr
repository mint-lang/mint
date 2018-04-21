message AccessExpectedVariable do
  title "Syntax Error"

  block do
    text "I was looking for the name of the field of a record but found"
    code got
    text "instead."
  end

  snippet node
end
