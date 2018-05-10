message ProviderExpectedColon do
  title "Syntax Error"

  block do
    text "The"
    bold "name"
    text "of a provider and the"
    bold "type of its subscription"
    text "must be separated by a"
    bold "colon"
    code ":"
  end

  was_looking_for "colon", got, ":"

  snippet node
end
