message StatementNotTuple do
  title "Type Error"

  block do
    text "The expression of the tuple destructuring is not a tuple."
  end

  block do
    text "I was expecting a "
    bold "Tuple"
  end

  type_with_text got, "Instead it is:"

  snippet node
end
