message ArgumentExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "An argument must have its type defined."
  end

  was_looking_for "type", got

  snippet node
end
