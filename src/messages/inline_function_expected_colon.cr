message InlineFunctionExpectedColon do
  title "Syntax Error"

  block do
    text "The"
    bold "body"
    text "of an"
    bold "anonymous function"
    text "and it's"
    bold "return type"
    text "must be separated by a"
    bold "colon"
    code ":"
  end

  was_looking_for "colon", got, ":"

  snippet node
end
