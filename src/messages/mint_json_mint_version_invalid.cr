message MintJsonMintVersionInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "Mint version constraint."
  end

  block do
    text "The version constraint should be in this format:"
  end

  block do
    bold "0.0.0 <= v < 1.0.0"
  end

  snippet node
end
