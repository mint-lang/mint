message EnumIdExpectedOption do
  title "Syntax Error"

  block do
    text "I was looking for an"
    bold "option"
    text "of an"
    bold "enum"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
