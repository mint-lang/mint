message EnumUnusedParameter do
  title "Type Error"

  block do
    text "The parameter"
    bold name
    text "was not used by any of the options."
  end

  block do
    text "Parameters must be used by at least one of the option."
  end

  snippet node
end
