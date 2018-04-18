message AccessNotRecord do
  title "Type Error"

  block do
    text "You are tyring to access a field on an object which is not a record: "
    code object
    text "."
  end

  snippet node
end
