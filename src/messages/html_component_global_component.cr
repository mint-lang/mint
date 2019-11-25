message HtmlComponentGlobalComponent do
  title "Type Error"

  block do
    text "The component named"
    bold name
    text "is global and cannot be used."
  end

  block do
    text "Global components are added to the body and always rendered."
  end

  snippet node
end
