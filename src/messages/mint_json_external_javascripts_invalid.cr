message MintJsonExternalJavascriptsInvalid do
  title "mint.json Error"

  block do
    text "The"
    bold "javascripts"
    text "field should be an array."
  end

  block do
    text "The"
    bold "javascripts"
    text "field lists all JavaScript files (relative to the mint.json file)"
    text "which should be compiled alongside the application."
  end

  snippet node
end
