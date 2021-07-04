message ArgumentExpectedColon do
  title "Syntax Error"

  block do
    text "A colon must separate the arguments name from its type."
  end

  was_looking_for "colon", got, ":"

  snippet node
end
