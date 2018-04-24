message ConnectExpectedExposing do
  title "Syntax Error"

  block do
    text "The"
    bold "list of functions and properties to expose"
    text "from a store and the"
    bold "name of the store"
    text "must be separated with an"
    code "exposing"
    text "keyword."
  end

  was_looking_for "keyword", got, "exposing"

  snippet node
end
