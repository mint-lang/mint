message PropertyExpectedType do
  title "Syntax Error"

  block do
    text "All properties must declare their type."
  end

  was_looking_for "type", got

  snippet node
end
