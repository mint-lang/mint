message AccessUnsafeComponent do
  title "Syntax Error"

  block do
    text "You are trying to access"
    code name
    text "of a components instance directly."
  end

  block do
    text "Component instances are not allways available and because of that"
    text "they are wrapped in a"
    code "Maybe"
  end

  block do
    text "Use the safe accesscor"
    code "&."
    text "to access it's functions and properties."
  end

  snippet node
end
