message MintJsonExternalStylesheetNotExists do
  title "mint.json Error"

  block do
    text "The external css file"
    bold path
    text "does not exist."
  end

  snippet node
end
