message EnumDestructuringExpectedDoubleColon do
  title "Syntax Error"

  block do
    text "The"
    bold "name"
    text "of an"
    bold "enum"
    text "and it's"
    bold "option"
    text "must be separated by a"
    bold "double colon"
    code "::"
  end

  was_looking_for "double colon", got, "::"

  snippet node
end
