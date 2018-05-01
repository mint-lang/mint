message PropertyExpectedDefaultValue do
  title "Syntax Error"

  block do
    text "The"
    bold "default value"
    text "of a property must be defined after the equal sign."
  end

  was_looking_for "default value", got

  snippet node
end
