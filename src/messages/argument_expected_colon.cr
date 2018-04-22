message ArgumentExpectedColon do
  title "Syntax Error"

  block do
    text "A colon must separate the arguments name from it's type."
  end

  was_looking_for "colon", got, ":"

  snippet node
end
