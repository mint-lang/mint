message IfExpectedCondition do
  title "Syntax Error"

  block do
    text "The"
    bold "condition"
    text "of an if expression"
    bold "must be a single expression."
  end

  was_looking_for "condition", got

  snippet node
end
