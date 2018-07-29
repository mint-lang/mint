message StateExpectedDefaultValue do
  title "Syntax Error"

  block do
    text "The"
    bold "default value"
    text "of a state must be defined after the equal sign."
  end

  was_looking_for "default value", got

  snippet node
end
