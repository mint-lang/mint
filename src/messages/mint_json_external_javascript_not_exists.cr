message MintJsonExternalJavascriptNotExists do
  title "mint.json Error"

  block do
    text "The external JavaScript file"
    bold path
    text "does not exist."
  end

  snippet node
end
