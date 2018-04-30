message FunctionExpectedColon do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of a"
    bold "function"
    text "and it's"
    bold "return type"
    text "must be separated by a"
    bold "colon"
    code ":"
  end

  was_looking_for "colon", got, ":"

  snippet node
end
