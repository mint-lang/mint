message MintJsonTestDirectoryNotExists do
  title "mint.json Error"

  block do
    text "The test directory"
    bold directory
    text "does not exists."
  end

  snippet node
end
