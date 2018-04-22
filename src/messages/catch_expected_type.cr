message CatchExpectedType do
  title "Syntax Error"

  block do
    text "In a catch you must specify"
    bold "the type"
    text "you want to handle."
  end

  was_looking_for "type", got

  snippet node
end
