message HtmlElementExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "I found a"
    bold "slash"
    code "/"
    text "which indicates that the element does not have children. A"
    bold "closing bracket"
    code ">"
    text "must follow the slash."
  end

  was_looking_for "closing bracket", got, ">"

  snippet node
end
