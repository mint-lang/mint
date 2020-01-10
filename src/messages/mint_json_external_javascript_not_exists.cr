message MintJsonExternalJavascriptNotExists do
  title "mint.json Error"

  block do
    text "The external JavaScript file"
    bold path
    text "does not exist."
  end

  block do
    text "Any external files should be"
    text "placed inside the \"public\" directory."
  end

  snippet node
end
