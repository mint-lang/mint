message ArrayAccessInvalidTuple do
  title "Type Error"

  block do
    text "The tuple only has"
    bold size
    text "members, but you wanted to access the"
    bold index
    text "."
  end

  type_with_text got, "The exact type of the tuple is:"

  snippet node
end
