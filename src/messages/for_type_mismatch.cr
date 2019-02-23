message ForTypeMismatch do
  title "Type Error"

  block do
    text "The iterable object of a for expression has an invalid type."
  end

  block do
    text "I was expecting one of the following types:"
  end

  pre "Array(a), Set(a), Map(a, b)"

  type_with_text got, "Instead it is:"

  snippet node
end
