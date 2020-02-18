message MintJsonMintVersionMismatch do
  title "mint.json Error"

  block do
    text "The"
    bold "mint-version"
    text "field in your"
    bold "mint.json"
    text "file does not match your current version of Mint."
  end

  block do
    text "I was looking for"
    bold expected_version

    text "but found"
    code current_version
    text "instead."
  end

  snippet node
end
