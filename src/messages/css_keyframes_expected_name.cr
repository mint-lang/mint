message CssKeyframesExpectedName do
  title "Syntax Error"

  block do
    text "An name of a keyframes must be defined."
  end

  was_looking_for "name", got

  snippet node
end
