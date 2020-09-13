message DocumentationDirectiveEntityNotFound do
  title "Environment Error"

  block do
    text "The entity for the documentation directive:"
    code name
    text "does not exists."
  end

  snippet node
end
