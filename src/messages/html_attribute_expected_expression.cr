message HtmlAttributeExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "value of an attribute"
    text "must be either a string literal or an expression"
    text "enclosed by brackets."
  end

  was_looking_for "expression", got

  snippet node
end
