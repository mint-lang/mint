message CaseBranchMultipleSpreads do
  title "Type Error"

  block do
    text "This array destructuring contains"
    code count
    text "spread notations."
  end

  block do
    text "An array destructuring can only contain one spread notations"
  end

  snippet node
end
