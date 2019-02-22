message ForExpectedBody do
  title "Syntax Error"

  block do
    text "A"
    bold "for expression"
    text "must have exactly"
    bold "one expression."
  end

  was_looking_for "expression", got

  snippet node
end
