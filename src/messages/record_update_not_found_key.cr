message RecordUpdateNotFoundKey do
  title "Type Error"

  block do
    text "The field"
    bold key
    text "does not exists on the target record:"
  end

  type target

  snippet node
end
