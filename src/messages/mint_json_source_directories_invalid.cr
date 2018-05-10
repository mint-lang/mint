message MintJsonSourceDirectoriesInvalid do
  title "mint.json Error"

  block do
    text "The"
    bold "source-directories"
    text "field should be an array."
  end

  block do
    text "The"
    bold "source-directories"
    text "field lists all directories (relative to the mint.json file)"
    text "which contain the source files of the application."
  end

  snippet node
end
