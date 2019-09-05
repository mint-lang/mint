message MintJsonIconNotString do
  title "mint.json Error"

  block do
    text "The"
    bold "icon"
    text "field of"
    bold "the application object"
    text "is not string:"
  end

  snippet node, nil
end
