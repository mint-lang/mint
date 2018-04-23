message ComponentFunctionTypeMismatch do
  title "Type Error"

  block do
    text "The type of the function"
    bold name
    text "of a component must be:"
  end

  type expected

  type_with_text got, "Instead it is:"
end
