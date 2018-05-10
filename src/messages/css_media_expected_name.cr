message CssMediaExpectedName do
  title "Syntax Error"

  block do
    text "A media query must define at least one media feature expression"
    text "after the ampersand."
  end

  was_looking_for "media feature expression", got

  snippet node
end
