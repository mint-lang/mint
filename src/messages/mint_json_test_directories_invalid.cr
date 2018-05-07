message MintJsonTestDirectoriesInvalid do
  title "mint.json Error"

  block do
    text "The"
    bold "test-directories"
    text "field should be an array."
  end

  block do
    text "The"
    bold "test-directories"
    text "field lists all directories (relative to the mint.json file)"
    text "which contain the test files of the application."
  end

  snippet node
end
