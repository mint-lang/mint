message MintJsonSourceDirectoryNotExists do
  title "mint.json Error"

  block do
    text "The source directory"
    bold directory
    text "does not exists."
  end

  snippet node
end
