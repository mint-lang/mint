message ConnectVariableExpectedAs do
  title "Syntax Error"

  block do
    text "The"
    bold "exposed name"
    text "of a state, fuction or computed property"
    bold "must be specified."
  end

  block do
    text "I was looking for"
    bold "the exposed name"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
