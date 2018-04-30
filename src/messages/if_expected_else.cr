message IfExpectedElse do
  title "Syntax Error"

  block do
    text "An"
    bold "if expression"
    text "must have an"
    bold "else branch."
  end

  was_looking_for "else branch", got

  snippet node
end
