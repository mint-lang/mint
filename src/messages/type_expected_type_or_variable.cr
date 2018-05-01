message TypeExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "A type with parameters must contain at least one parameter."
  end

  was_looking_for "type or type parameter", got

  snippet node
end
