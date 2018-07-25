message InlineFunctionExpectedType do
  title "Syntax Error"

  block do
    text "The return type of an"
    bold "anonymous function"
    text "must be defined."
  end

  was_looking_for "return type", got

  snippet node
end
