message HtmlComponentExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I could not parse further. I was looking for one of the following:"
  end

  list [
    "an attribute for the component",
    "a reference to the component \"as component\"",
    "\"/>\" for self closing components",
    "\">\" for non self closing components",
  ]

  block do
    text "but found"
    code got
    text "instead."
    text "You can read more about components here: https://www.mint-lang.com/guide/reference/components"
  end

  snippet node
end
