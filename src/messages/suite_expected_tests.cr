message SuiteExpectedTests do
  title "Syntax Error"

  block do
    text "I was looking for at least one"
    bold "test"
    text "for a"
    bold "test suite"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
