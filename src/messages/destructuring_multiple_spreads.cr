message DestructuringMultipleSpreads do
  title "Type Error"

  block do
    text "This array destructuring contains"
    code count
    text "spread notations."
  end

  block do
    text "An array destructuring can only contain one spread notation."
  end

  snippet node
end
