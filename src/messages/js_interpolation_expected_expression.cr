message JsInterpolationExpectedExpression do
  title "Syntax Error"

  block do
    text "The"
    bold "body of an JavaScript interpolation"
    text "must be a single expression."
  end

  was_looking_for "expression", got

  snippet node
end
