message AccessFieldNotRecord do
  title "Type Error"

  block do
    text "You are tyring to access the field "
    code field
    text " on an object which is not a record: "
    code object
    text "."
  end

  snippet node
end
