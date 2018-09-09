message EnumNotDefinedParameter do
  title "Type Error"

  block do
    text "The parameter"
    bold name
    text "was not defined in the type of the enum."
  end

  block do
    text "Parameters used by options must be defined in the type of the enum."
  end

  snippet node
end
