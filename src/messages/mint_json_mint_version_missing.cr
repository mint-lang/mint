message MintJsonMintVersionMissing do
  title "mint.json Error"

  block do
    text "The"
    code "mint-version"
    text "field was not found in this"
    bold "mint.json"
    text "file."
  end

  block do
    bold contents
  end
end
