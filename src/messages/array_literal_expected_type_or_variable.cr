message ArrayLiteralExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "The type of an"
    bold "array literal"
    text "must be defined after the"
    bold "of"
    text "keyword."
  end

  was_looking_for "type", got

  snippet node
end
