message InlineFunctionExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of an"
    bold "inline function"
    text "must be a single expression."
  end

  was_looking_for "expression", got

  snippet node
end
