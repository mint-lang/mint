message ConnectExpectedKeys do
  title "Syntax Error"

  block do
    text "The"
    bold "list of functions and properties to expose"
    text "from a store must not be empty."
  end

  block do
    text "I was looking for"
    bold "something to expose"
    text "but found"
    code got
    text "instead"
  end

  snippet node
end
