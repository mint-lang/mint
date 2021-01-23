message CssNestedAtExpectedCondition do
  title "Syntax Error"

  block do
    text "An at rule must define at least one condition."
  end

  was_looking_for "condition", got

  snippet node
end
