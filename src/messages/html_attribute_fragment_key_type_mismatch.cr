message HtmlAttributeFragmentKeyTypeMismatch do
  title "Type Error"

  block do
    text "The"
    bold "key"
    text "attribute of a fragment has an invalid type. It can only be:"
    code "String"
  end

  was_expecting_type expected, got

  snippet node
end
