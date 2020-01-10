message MintJsonExternalStylesheetsInvalid do
  title "mint.json Error"

  block do
    text "The"
    bold "stylesheets"
    text "field should be an array."
  end

  block do
    text "The"
    bold "stylesheets"
    text "field lists all CSS files (relative to the mint.json file)"
    text "which should be included alongside the application."
  end

  snippet node
end
