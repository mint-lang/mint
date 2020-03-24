message RecordConstructorNotFoundRecord do
  title "Type Error"

  block do
    text "I could not find a record with the name:"
    bold name
  end

  snippet node, "It was used here:"
end
