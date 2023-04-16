message MintJsonTestDirectoryInvalid do
  title "mint.json Error"

  block do
    text "All entries in the"
    bold "test-directories"
    text "array should be string."
  end

  snippet node, "I found one that it is not:"
end
