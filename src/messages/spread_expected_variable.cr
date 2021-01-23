message SpreadExpectedVariable do
  title "Syntax Error"

  block do
    text "Spread notation must have"
    bold "a variable"
    text "to hold the values."
  end

  was_looking_for "variable", got

  snippet node
end
