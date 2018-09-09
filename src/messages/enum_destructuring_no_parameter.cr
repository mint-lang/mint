message EnumDestructuringNoParameter do
  title "Type Error"

  block do
    text "You are trying to destructure the"
    bold index
    text "parameter from the enum option:"
    bold name
  end

  block do
    text "The option only has"
    bold size
    text "parameters."
  end

  snippet node, "You are trying to destructure it here:"
  snippet option, "The option is defined here:"
end
