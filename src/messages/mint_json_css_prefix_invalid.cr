message MintJsonCssPrefixInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "css-prefix field"
    text "of an"
    bold "application"
    text "object:"
  end

  snippet node, nil
end
