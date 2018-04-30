message ModuleCallNotFoundFunction do
  title "Type Error"

  block do
    text "The function"
    bold name
    text "you tried to call does not exists in the module or store"
    bold module_name
  end

  snippet node
end
