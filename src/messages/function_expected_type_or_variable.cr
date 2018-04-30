message FunctionExpectedTypeOrVariable do
  title "Syntax Error"

  block do
    text "The return type of a"
    bold "function"
    text "must be defined."
  end

  was_looking_for "return type", got

  snippet node
end
