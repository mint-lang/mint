message StateExpectedColon do
  title "Syntax Error"

  block do
    text "The"
    bold "name"
    text "of a state and its"
    bold "type"
    text "must be separated by a"
    bold "colon"
    code ":"
  end

  was_looking_for "colon", got, ":"

  snippet node
end
