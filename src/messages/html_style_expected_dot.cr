message HtmlStyleExpectedDot do
  title "Syntax Error"

  block do
    text "The"
    bold "name of the style"
    text "must be separated by a dot from the"
    bold "name of the styles block."
  end

  was_looking_for "dot", got, "."

  snippet node
end
