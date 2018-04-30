message HtmlContentTypeMismatch do
  title "Type Error"

  block do
    text "A child node of an element or component has an invalid type."
  end

  block do
    text "I was expecting one of the following types:"
  end

  pre "Html, String, Array(String), Array(Html)"

  type_with_text got, "Instead it is:"

  snippet node
end
