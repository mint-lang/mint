message DoDidNotCatch do
  title "Type Error"

  block do
    text "I am checking if all the possible errors are handled in a do expression."
  end

  block do
    text "I found that these types are not handled:"
  end

  type_list remaining

  snippet node
end
