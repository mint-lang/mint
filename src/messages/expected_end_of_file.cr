message ExpectedEndOfFile do
  title "Syntax Error"

  block do
    text "I was expecting any of the top level constructs:"
  end

  list [
    "Component",
    "Module",
    "Record",
    "Enum",
    "Provider",
    "Routes",
    "Store",
    "Suite",
  ]

  block do
    text "Instead I found"
    code got
  end

  snippet node
end
