message HtmlComponentAttributeRequired do
  title "Type Error"

  block do
    text "One of the required properties were not specified for a component."
  end

  snippet property_node, "The property in question is:"
  snippet node, "The component was referenced here:"
end
