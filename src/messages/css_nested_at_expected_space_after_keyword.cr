message CssNestedAtExpectedSpaceAfterKeyword do
  title "Syntax Error"

  block do
    text "There must be a space between the"
    bold "at rule"
    text "and any"
    bold "conditions."
  end

  was_looking_for "space", got

  snippet node
end
