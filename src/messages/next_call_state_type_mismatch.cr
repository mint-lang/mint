message NextCallStateTypeMismatch do
  title "Type Error"

  block do
    text "You were trying to assign an incompatible value to the status state."
  end

  block do
    text "The type of the state is:"
    bold expected
  end

  block do
    text "But the type you are trying to assign to it:"
    bold got
  end

  snippet node, "Here is where you did the assignment:"
  snippet state, "And here is where the state is defined:"
end
