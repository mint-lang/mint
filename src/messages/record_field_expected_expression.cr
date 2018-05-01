message RecordFieldExpectedExpression do
  title "Syntax Error"

  block do
    text "A field must have"
    bold "value (expression)"
    text "after the equal sign."
  end

  was_looking_for "expression", got

  snippet node
end
