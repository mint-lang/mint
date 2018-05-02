message WithNotFoundModule do
  title "Type Error"

  block do
    text "I was look for the module named:"
    bold name
    text "for a with expression but could not find it."
  end

  snippet node
end
