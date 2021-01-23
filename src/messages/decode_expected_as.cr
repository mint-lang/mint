message DecodeExpectedAs do
  title "Syntax Error"

  block do
    text "The"
    bold "object to be decoded"
    text "and the"
    bold "type"
    text "must be separated by an"
    bold "as"
    text "keyword."
  end

  was_looking_for "as keyword", got

  snippet node
end
