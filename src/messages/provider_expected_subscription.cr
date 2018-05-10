message ProviderExpectedSubscription do
  title "Syntax Error"

  block do
    text "I was looking for the"
    bold "type of the subscription"
    text "of a"
    bold "provider"
    text "but found"
    code got
    text "instead."
  end

  snippet node
end
