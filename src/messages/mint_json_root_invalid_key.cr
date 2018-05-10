message MintJsonRootInvalidKey do
  title "mint.json Error"

  block do
    text "The root object of a"
    bold "mint.json"
    text "file has an invalid key:"
    bold key
  end

  snippet node
end
