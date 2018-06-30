message HtmlElementClassNameForbidden do
  title "Type Error"

  block do
    text "The className attribute on elements are forbidden."
  end

  block do
    text "Please use"
    bold "class"
    text "instead."
  end

  snippet node
end
