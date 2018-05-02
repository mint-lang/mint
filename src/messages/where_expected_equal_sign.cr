message WhereExpectedEqualSign do
  title "Syntax Error"

  block do
    text "A where statement must have an"
    bold "equal sign"
    text "before the expression."
  end

  was_looking_for "equal sign", got, "="

  snippet node
end
