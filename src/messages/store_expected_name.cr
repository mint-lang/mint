message StoreExpectedName do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name of a store"
    text "but found"
    code got
    text "instead."
  end

  block do
    text "The name of a store must start with an uppercase letter and only"
    text "contain lowercase, uppercase letters and numbers."
  end

  snippet node
end
