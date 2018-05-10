message CssSelectorSpaceAfterAmpersand do
  title "Syntax Error"

  block do
    text "There must be a space between the ampersand"
    code "&"
    text "and the selector, if it's not a pseudo one."
  end

  was_looking_for "space", got

  snippet node
end
