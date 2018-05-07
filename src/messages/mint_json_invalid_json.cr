message MintJsonInvalidJson do
  title "mint.json Error"

  block do
    text "I could not parse the following"
    bold "mint.json"
    text "file:"
  end

  snippet node, nil
end
