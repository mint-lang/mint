message UseExpectedOpeningBracket do
   title "Syntax Error"

  block do
    text "The"
    bold "expression"
    text "for a"
    bold "when codition"
    text "must be enclosed by brackets."
  end

  was_looking_for "opening bracket", got, "{"

  snippet node
end
