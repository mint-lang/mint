message EnumDestructuringExpectedClosingParentheses do
  title "Syntax Error"

  block do
    text "I was looing for the"
    code ")"
    text "after paranthesed parameter in enum destructuring, but found"
    code got
    text "instead."
  end
end
