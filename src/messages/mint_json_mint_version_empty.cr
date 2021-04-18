message MintJsonMintVersionEmpty do
  title "mint.json Error"

  block do
    text "The"
    bold "mint-version"
    text "field in your"
    bold "mint.json"
    text "file is empty."
  end

  snippet node, nil
end
