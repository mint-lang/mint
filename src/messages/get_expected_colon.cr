message GetExpectedColon do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of a"
    bold "get"
    text "and it's"
    bold "return type"
    text "must be separated by a colon."
  end

  was_looking_for "colon", got, ":"

  snippet node
end
