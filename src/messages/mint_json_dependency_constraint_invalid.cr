message MintJsonDependencyConstraintInvalid do
  title "mint.json Error"

  block do
    text "There was a problem when parsing the"
    bold "constraint"
    text "of a dependency:"
  end

  snippet node, nil
end
