message ModuleAccessNotFoundFunction do
  title "Type Error"

  block do
    text "The entity"
    bold name
    text "you tried to reference does not exists in the module or store"
    bold entity
  end

  snippet node
end
