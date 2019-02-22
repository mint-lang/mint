message ForExpectedSubject do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "subject"
    text "of a for expression"

    text "but found"
    code got
    text "instead."
  end

  snippet node
end
