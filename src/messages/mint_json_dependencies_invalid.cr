message MintJsonDependenciesInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "dependencies"
    text "field of a mint.json file."
  end

  block do
    text "The"
    bold "dependencies"
    text "field lists all the dependencies for the application."
  end

  snippet node
end
