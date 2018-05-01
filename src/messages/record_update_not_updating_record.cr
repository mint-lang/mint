message RecordUpdateNotUpdatingRecord do
  title "Type Error"

  block do
    text "The"
    bold "target of a record update"
    text "is not a record, instead it is:"
  end

  type target

  snippet node, "Here is where you want to update it:"
  snippet target_node, "Here is where the target is defined:"
end
