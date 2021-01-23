message EnvFileNotFound do
  title "Environment Error"

  block do
    text "The environment file specified"
    code name
    text "does not exists"
  end
end
