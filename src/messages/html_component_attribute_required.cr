message HtmlComponentAttributeRequired do
  title "Type Error"

  block do
    text "One of the required properties were not specified for a component."
  end

  snippet "The property in question is:", property
  snippet "The component was refereced here:", node
end
