message MintJsonDependencyNotInstalled do
  title "mint.json Error"

  block do
    text "Not all"
    bold "dependencies"
    text "in your mint.json file are installed."
  end

  block do
    text "The dependency"
    bold name
    text "was expected to be in the"
    bold ".mint/packages/#{name}"
    text "directory."
  end

  block do
    text "Usually you can fix this by running the"
    bold "mint install"
    text "command."
  end
end
