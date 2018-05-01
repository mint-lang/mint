message StringExpectedOtherString do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "an ohter string literal"
    text "after a"
    bold "string separator"
    code "\\"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
