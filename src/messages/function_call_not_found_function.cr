message FunctionCallNotFoundFunction do
  title "Type Error"

  block do
    text "I cannot find a function with the name"
    bold "#{name}."
  end

  snippet node
end
