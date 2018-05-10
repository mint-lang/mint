message MintJsonDependencyInvalidConstraint do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "constraint"
    text "of a dependency"
  end

  block do
    text "The constraint of a dependency is either in this format:"
  end
  block do
    bold "0.0.0 <= v < 1.0.0"
  end

  block do
    text "or a git tag / commit / branch followed by the version:"
  end

  block do
    bold "master:0.1.0"
  end

  block do
    text "I could not find either."
  end

  snippet node
end
