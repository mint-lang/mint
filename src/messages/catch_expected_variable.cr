message CatchExpectedVariable do
  title "Syntax Error"

  block do
    text "In a catch you must specify"
    bold "a variable"
    text "to hold the"
    bold "catched value."
  end

  was_looking_for "variable", got

  snippet node
end
