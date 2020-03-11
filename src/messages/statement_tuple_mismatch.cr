message StatementTupleMismatch do
  title "Type Error"

  block do
    text "I tried to destructure"
    bold variables
    text "from a tuple of"
    bold parameters
    text "elements."
  end

  block do
    text "I was expecting a"
    bold "Tuple"
    text "with"
    bold parameters
    text "elements."
  end

  type_with_text got, "The actual tuple is:"

  snippet node
end
