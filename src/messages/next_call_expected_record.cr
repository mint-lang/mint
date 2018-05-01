message NextCallExpectedRecord do
  title "Syntax Error"

  block do
    text "I was looking for a"
    bold "record, record update or variable"
    text "for a"
    bold "next call"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
