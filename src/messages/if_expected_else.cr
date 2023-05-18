message IfExpectedElse do
  title "Type Error"

  block do
    text "This"
    bold "if expression"
    text "must have an"
    bold "else branch."
  end

  block do
    text "The elese branch can be omitted if the truthy branch returns one of:"
    type_list expected
    text "but it returns"
    type got
  end

  snippet node
end
