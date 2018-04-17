message AccessExpectedVariable do
  title "Syntax Error"

  block do
    text "I was looking for the name of the field of the record but found "
    bold got
    text " instead."
  end

  snippet node
end
