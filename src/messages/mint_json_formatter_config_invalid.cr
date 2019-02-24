message MintJsonFormatterConfigInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "formatter-config"
    text "object of a"
    bold "mint.json"
    text "file:"
  end

  snippet node, nil
end
