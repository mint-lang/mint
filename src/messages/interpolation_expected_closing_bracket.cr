message InterpolationExpectedClosingBracket do
  title "Syntax Error"

  block do
    text "A CSS interpolation must end with a closing bracket."
  end

  was_looking_for "bracket", got, "}"

  snippet node
end
