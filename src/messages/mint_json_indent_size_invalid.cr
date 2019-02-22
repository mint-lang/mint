message MintJsonIndentSizeInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "indent-size field"
    text "of an"
    bold "formatter-config"
    text "object:"
  end

  snippet node, nil
end
