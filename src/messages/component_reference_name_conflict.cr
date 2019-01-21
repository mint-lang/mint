message ComponentReferenceNameConflict do
  title "Type Error"

  block do
    text "There are multiple references with the name:"
    bold "#{name}."
  end

  snippet node, "One reference is here:"
  snippet other, "An other reference is here:"
end
