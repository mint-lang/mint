message FunctionArgumentConflict do
  title "Type Error"

  block do
    text "The argument"
    bold name
    text "is declared multiple times."
  end

  snippet other, "It is declared here:"
  snippet node, "It is also declared here:"
end
