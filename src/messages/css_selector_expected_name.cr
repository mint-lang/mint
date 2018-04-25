message CssSelectorExpectedName do
  title "Syntax Error"

  block do
    text "A sub selector must define a selector after the ampersand."
  end

  was_looking_for "selector", got

  snippet node
end
