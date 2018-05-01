message UseExpectedProvider do
  title "Syntax Error"

  block do
    text "I was looking for a"
    bold "provider"
    text "for a"
    bold "use directive"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
