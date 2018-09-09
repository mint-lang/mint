message MintJsonThemeInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "theme field"
    text "of an"
    bold "application"
    text "object:"
  end

  snippet node, nil
end
