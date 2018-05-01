message UseExpectedRecord do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "data"
    text "for a"
    bold "use directive"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
