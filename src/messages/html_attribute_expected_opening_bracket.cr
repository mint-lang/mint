message HtmlAttributeExpectedOpeningBracket do
  title "Syntax Error"

  block do
    text "The"
    bold "value of an attribute"
    text "must be either a string literal or an expression"
    text "enclosed by brackets."
  end

  block do
    text "I was looking for the"
    bold "opening bracket"
    code "{"

    text "for the expression but found"
    code got
    text "instead."
  end

  snippet node
end
