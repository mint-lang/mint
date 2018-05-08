message MintJsonMetaValueNotString do
  title "mint.json Error"

  block do
    text "The"
    bold "value"
    text "of a"
    bold "meta field"
    text "is not a string:"
  end

  snippet node, nil
end
