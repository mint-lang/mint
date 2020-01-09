message MintJsonExternalInvalid do
  title "mint.json Error"

  block do
    text "The"
    bold "external"
    text "field contain at least one item."
  end

  block do
    text "The"
    bold "javascripts"
    text "field lists all JavaScript files (relative to the mint.json file)"
    text "which should be compiled alongside the application."
  end

  block do
    text "The"
    bold "stylesheets"
    text "field lists all CSS files (relative to the mint.json file)"
    text "which should be included alongside the application."
  end

  snippet node
end
