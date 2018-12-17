message EnvNotFoundVariable do
  title "Type Error"

  block do
    text "I cannot find the environment variable with the name"
    bold "#{name}"
  end

  snippet node
end
