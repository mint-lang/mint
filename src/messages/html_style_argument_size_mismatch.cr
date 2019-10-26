message HtmlStyleArgumentSizeMismatch do
  title "Type Error"

  block do
    text "The style takes"
    bold size
    text "arguments, while you tried to call it with"
    bold call_size
  end

  snippet node, "You tried to call it here:"
end
