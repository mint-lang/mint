message ArgumentExpectedColon do
  title "Syntax Error"

  block do
    text "I was looking for the "
    bold "colon "
    code ":"
    text " that separates the argument from its type but found "
    bold got
    text " instead."
  end

  snippet node
end
