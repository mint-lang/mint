message MintJsonTitleIsEmpty do
  title "mint.json Error"

  block do
    text "The"
    bold "title"
    text "field of an"
    bold "application object"
    text "is empty:"
  end

  snippet node, nil
end
