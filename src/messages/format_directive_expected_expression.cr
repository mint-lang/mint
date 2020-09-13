message FormatDirectiveExpectedExpression do
  title "Syntax Error"

  block do
    text "A format directive must have exactly"
    bold "one expression."
  end

  was_looking_for "expression", got

  snippet node
end
