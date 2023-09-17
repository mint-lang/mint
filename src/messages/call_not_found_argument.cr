message CallNotFoundArgument do
  title "Type Error"

  block do
    text "I was looking for the argument:"
    bold name
    text "but it's not there."
  end

  type_with_text function_type, "The type of the function is:"

  snippet node, "The call is here:"
end
