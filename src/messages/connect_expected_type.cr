message ConnectExpectedType do
  title "Syntax Error"

  block do
    text "A"
    bold "connect statement"
    text "must specify the"
    bold "name of the store"
    text "after the"
    code "connect"
    text "keyword."
  end

  block do
    text "I was looking for"
    bold "name of the store"
    text "but found"
    code got
    text "instead"
  end

  snippet node
end
