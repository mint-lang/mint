message MintJsonFormatterConfigInvalidKey do
  title "mint.json Error"

  block do
    text "The"
    bold "formatter-config"
    text "object of a"
    bold "mint.json"
    text "file has an invalid key:"
    bold key
  end

  snippet node
end
