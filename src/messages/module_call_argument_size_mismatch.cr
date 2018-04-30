message ModuleCallArgumentSizeMismatch do
  title "Type Error"

  block do
    text "You tried to call the function"
    bold name
    text "with more or less arguments."
  end

  block do
    text "The function takes"
    bold size
    text "arguments, while you tried to call it with"
    bold call_size
  end

  snippet node, "You tried to call it here:"
  snippet function, "The called function is defined here:"
end
