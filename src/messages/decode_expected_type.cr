message DecodeExpectedType do
  title "Syntax Error"

  block do
    text "The"
    bold "type"
    text "of which to decode to must follow the"
    bold "as"
    text "key."
  end

  was_looking_for "type", got

  snippet node
end
