message AccessFieldNotFound do
  title "Type Error"

  block do
    text "The field"
    code field
    text "does not exists on the record:"
  end

  type target

  snippet node
end
