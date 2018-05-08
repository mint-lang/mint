message MintJsonDependencyInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing a"
    bold "dependency"
    text "of a mint.json file:"
  end

  snippet node
end
