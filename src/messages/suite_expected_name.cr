message SuiteExpectedName do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name"
    text "of a"
    bold "test suite"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
