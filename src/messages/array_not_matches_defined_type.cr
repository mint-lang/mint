message ArrayNotMatchesDefinedType do
  title "Type Error"

  block do
    text "The"
    bold "defined type"
    text "of an array does not match the type of its items."
  end

  was_expecting_type expected, got

  snippet node
end
