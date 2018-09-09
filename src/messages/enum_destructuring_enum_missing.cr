message EnumDestructuringEnumMissing do
  title "Type Error"

  block do
    text "I could not find the option"
    bold name
    text "of enum"
    bold parent_name
  end

  snippet node, "You tried to reference it here:"
  snippet parent, "The enum is defined here:"
end
