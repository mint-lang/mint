message WhereExpectedWhere do
  title "Syntax Error"

  block do
    text "A where block must have at least one statement."
  end

  was_looking_for "statement", got

  snippet node
end
