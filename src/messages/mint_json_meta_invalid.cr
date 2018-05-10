message MintJsonMetaInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "meta object"
    text "of an"
    bold "application object"
    text "file:"
  end

  snippet node, nil
end
