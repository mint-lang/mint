message MintJsonApplicationInvalidKey do
  title "mint.json Error"

  block do
    text "The"
    bold "application object"
    text "of a"
    bold "mint.json"
    text "file has an invalid key:"
    bold key
  end

  snippet node
end
