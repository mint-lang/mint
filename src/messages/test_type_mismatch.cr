message TestTypeMismatch do
  title "Type Error"

  block do
    text "The type of a test does not match any of the allowed types."
  end

  block do
    text "I was expecting one of:"
  end

  pre "Bool, Test.Context(a)"

  type_with_text got, "Instead it is:"

  snippet node
end
