message ConnectNotFoundMember do
  title "Type Error"

  block do
    text "The"
    bold key
    text "function, property or computed property does not exists for the store:"
    bold store
  end

  snippet node
end
