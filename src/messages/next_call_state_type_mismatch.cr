message NextCallStateTypeMismatch do
  title "Type Error"

  block do
    text "You were trying to assign an incompatible value to the status state."

    text "\nThe type of the state is:"
    bold expected

    text "\nBut the type you are trying to assign to it:"
    bold got
  end

  snippet(node, message = "Here is where you did the assignment:")
  snippet(state, message = "And here is where the state is defined:")
end
