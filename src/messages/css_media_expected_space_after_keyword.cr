message CssMediaExpectedSpaceAfterKeyword do
  title "Syntax Error"

  block do
    text "There must be a space between the"
    bold "@media keyword"
    text "and any"
    bold "media feature expressions."
  end

  was_looking_for "space", got

  snippet node
end
