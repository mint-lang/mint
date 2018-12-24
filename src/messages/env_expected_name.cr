message EnvExpectedName do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "name"
    text "of an"
    bold "environment variable"
    text "but found"
    code got
    text "instead."
  end

  block do
    text "The name of an environment variable must be uppercase"
  end

  snippet node
end
