message ConstantExpectedValue do
  title "Syntax Error"

  block do
    text "The"
    bold "value"
    text "of a constant must be defined after the equal sign."
  end

  was_looking_for "value", got

  snippet node
end
