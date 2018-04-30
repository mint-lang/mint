message JsExpectedClosingTick do
  title "Syntax Error"

  block do
    text "A"
    bold "JavaScript expression"
    text "is enclosed by"
    bold "backticks."
  end

  was_looking_for "backtick", got, "`"

  snippet node
end
