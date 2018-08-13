message CaseEnumNotCovered do
  title "Type Error"

  block do
    text "Not all possibilities of a case expression are covered."
  end

  block do
    text "To cover all remaning possibilities create branches for the following options:"
  end

  list options

  snippet node
end
