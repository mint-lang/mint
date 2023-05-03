message DestructuringTypeMismatch do
  title "Type Error"

  block do
    text "A value does not match its supposed type."
  end

  block do
    text "I was expecting:"
  end

  type expected

  block do
    text "Instead it is:"
  end

  type got

  snippet node
end
