message DestructuringTupleMismatch do
  title "Type Error"

  block do
    text "This destructuring of a tuple does not match the given tuple."
  end

  block do
    text "I was expecting a tuple with"
    bold size
    text "parameters."
  end

  block do
    text "Instead it is this:"
  end

  type got

  snippet node
end
