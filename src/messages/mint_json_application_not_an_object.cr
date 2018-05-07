message MintJsonApplicationNotAnObject do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "application object"
    text "of a"
    bold "mint.json"
    text "file."
  end

  snippet node
end
