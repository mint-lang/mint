message AccessCallArgumentSizeMismatch do
  title "Type Error"

  block do
    text "You tried to call a function with more or less arguments."
  end

  block do
    text "The function takes"
    bold size.to_s
    text "arguments and you tried to call it with"
    bold call_size.to_s
  end

  snippet node, "You tried to call it here:"
end
