message StoreExpectedBody do
  title "Syntax Error"

  block do
    text "I was looking for at least one"
    bold "function, state or computed property"
    text "for this store but found"
    code got
    text "instead."
  end

  snippet node
end
